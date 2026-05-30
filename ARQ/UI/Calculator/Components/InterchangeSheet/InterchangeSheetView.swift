//
//  InterchangeSheetView.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import SwiftUI

struct InterchangeSheetView: View {
    
    @StateObject var vm = InterchangeSheetViewModel()
    
    @Binding var mainCurrency: String
    
    @Binding var selectedCurrency: String
    
    var currencies: [String]
    
    let error: Bool
    
    let onDismiss: () -> Void
    
    let onCurrencySelect: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                
                Text(vm.chooseCurrencyTitle)
                    .defaultFont(size: 22, weight: .semiBold)
                
                Spacer()
                
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: vm.dismissButtonIcon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.foreground)
                        .opacity(0.8)
                }
                
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 16)
            
            VStack(spacing: 0) {
                
                let currencyList = vm.currencyList(currencies, mainCurrency)
                
                Group {
                    if error {
                        HStack {
                            Text(vm.errorMessageLabel)
                                .defaultFont()
                            Spacer()
                            Image(systemName: vm.errorIcon)
                                .resizeSystemImage(width: 17, height: 17)
                        }
                    } else if currencyList.isEmpty {
                        HStack {
                            Text(vm.loadingCurrenciesLabel)
                                .defaultFont()
                            Spacer()
                            ProgressView()
                        }
                    }
                    
                }
                .padding()
                
                ForEach(currencyList, id: \.self) { currency in
                    
                    HStack(spacing: 12) {
                        
                        SheetCurrencyIconView(currency: currency)
                        
                        Spacer()
                        
                        SelectionIconView(selected: currency == selectedCurrency)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onCurrencySelect(currency)
                    }
                }
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
}
