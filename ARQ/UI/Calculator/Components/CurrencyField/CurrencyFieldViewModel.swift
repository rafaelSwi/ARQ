//
//  CurrencyFieldViewModel.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import Combine
import SwiftUI

@MainActor
final class CurrencyFieldViewModel: ObservableObject {
    
    let interchangeableButtonIcon: String = "chevron.down"
    
    let clipPadding: CGFloat = 20
    
    let clipCornerRadius: CGFloat = 16
    
    private let maxArraySize: Int = 18
    
    private var consecutiveBackspaces: Int = 0
    
    @Published var input: String = "|"
    
    @Published var store: [String] = []
    
    @Published var selection: TextSelection?
    
    func visibleInput(_ active: Bool) -> String {
        let filtered = store.filter { $0 != "$" }
        let (integerPart, decimalPart) = splitIntegerAndDecimal(filtered)
        let formattedInteger = formatWithThousandSeparator(integerPart)
        
        var result = "$" + formattedInteger
        if let decimal = decimalPart {
            result += "." + decimal
        }
        if !active && store.count >= maxArraySize {
            result += "…"
        }
        return result
    }
    
    func resetUserInput() {
        input = "|"
        persistTextSelectionAtTheEnd()
    }
    
    func resetConsecutiveBackspaces() {
        consecutiveBackspaces = 0
    }
    
    func registerInput() {
        let allowedInputs = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ",", "."]
        
        let typed = input.replacingOccurrences(of: "|", with: "")
        
        guard input != "|" else { return }
        
        if typed.isEmpty {
            if !store.isEmpty {
                if consecutiveBackspaces >= 7 {
                    VibrationUtils.deniabilityVibrate()
                    store.removeAll()
                } else {
                    consecutiveBackspaces += 1
                    store.removeLast()
                }
            }
        } else if allowedInputs.contains(typed) {
            resetConsecutiveBackspaces()
            appendToStore(typed)
        }
        
        resetUserInput()
    }
    
    func convertToCurrencyValue(_ store: [String]) -> Double {
        let joined = store
            .filter { $0 != "$" }
            .joined()
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: CharacterSet(charactersIn: "."))
        
        return Double(joined) ?? 0.0
    }
    
    func currencyValueChangedAction(active: Bool, value: Double) {
        if !active {
            store =  convertDoubleToStore(value)
        }
    }
    
    func persistTextSelectionAtTheEnd() {
        selection = TextSelection(insertionPoint: input.endIndex)
    }
    
    @ViewBuilder
    func currencyIcon(_ currency: String) -> some View {
        let name = CurrencyUtils.currencyIconName(currency)
        if UIImage(named: name) != nil {
            Image(name)
                .resizable()
        } else {
            Image("currency_icon_unknown")
        }
    }
    
    private func splitIntegerAndDecimal(_ parts: [String]) -> ([String], String?) {
        guard let sepIndex = parts.firstIndex(where: { $0 == "," || $0 == "." }) else {
            return (parts, nil)
        }
        let integerPart = Array(parts.prefix(upTo: sepIndex))
        let decimalPart = Array(parts.suffix(from: parts.index(after: sepIndex))).joined()
        return (integerPart, decimalPart)
    }
    
    private func formatWithThousandSeparator(_ parts: [String]) -> String {
        let joined = parts.joined()
        return joined.reversed()
            .enumerated()
            .map { $0.offset > 0 && $0.offset % 3 == 0 ? "\($0.element)," : "\($0.element)" }
            .reversed()
            .joined()
    }
    
    private func convertDoubleToStore(_ value: Double) -> [String] {
        let isInteger = value.truncatingRemainder(dividingBy: 1) == 0
        
        let formatted: String
        if isInteger {
            formatted = String(format: "%.0f", value)
        } else {
            let decimalPart = value - Double(Int(value))
            var significantDecimals = 2
            if decimalPart != 0 {
                let digits = Int(ceil(-log10(abs(decimalPart))))
                significantDecimals = max(2, digits + 1)
            }
            formatted = String(format: "%.\(significantDecimals)f", value)
                .replacingOccurrences(of: ".", with: ",")
        }
        
        let result = formatted.map { String($0) }
        return Array(result.prefix(18))
    }
    
    private func appendToStore(_ typed: String) {
        guard store.count < maxArraySize else { return }
        
        let hasDecimalSeparator = store.contains(",") || store.contains(".")
        if (typed == "," || typed == ".") && hasDecimalSeparator {
            return
        }
        
        store.append(typed)
    }
    
}
