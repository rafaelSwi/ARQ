//
//  CurrencyFieldView.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import SwiftUI

struct CurrencyFieldView: View {
    
    @StateObject var vm = CurrencyFieldViewModel()
    
    @Binding var value: Double
    
    @Binding var currency: String
    
    var active: Bool
    
    let interchangeableAction: (() -> Void)?
    
    let onFocus: (() -> Void)
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            
            vm.currencyIcon(currency)
                .frame(width: 16, height: 16)
            
            Group {
                Group {
                    
                    Text(CurrencyUtils.currencyName(currency))
                    
                    if interchangeableAction != nil {
                        Image(systemName: vm.interchangeableButtonIcon)
                            .resizeSystemImage(width: 12, height: 12)
                            .offset(y: 2)
                    }
                    
                }
                .onTapGesture {
                    interchangeableAction?()
                }
                
                Spacer()
                
                ZStack {
                    HStack {
                        
                        Spacer()
                        
                        Text(vm.visibleInput(active))
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                            .defaultFont()
                            .offset(x: -2)
                            .onChange(of: value) {
                                vm.currencyValueChangedAction(active: active, value: value)
                            }
                    }
                    
                    TextField("", text: $vm.input, selection: $vm.selection)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.opacity(0.0))
                        .focused($isFocused)
                        .onChange(of: vm.input) {
                            vm.registerInput()
                            value = vm.convertToCurrencyValue(vm.store)
                        }
                    
                }
                .onChange(of: isFocused) {
                    if isFocused {
                        vm.persistTextSelectionAtTheEnd()
                        vm.resetConsecutiveBackspaces()
                        onFocus()
                    }
                }
                
            }
            .defaultFont(weight: .semiBold)
            
        }
        .padding(vm.clipPadding)
        .background(.stockButton)
        .clipShape(RoundedRectangle(cornerRadius: vm.clipCornerRadius))
        .onChange(of: vm.selection) {
            if active {
                vm.persistTextSelectionAtTheEnd()
            }
        }
        
    }
}
