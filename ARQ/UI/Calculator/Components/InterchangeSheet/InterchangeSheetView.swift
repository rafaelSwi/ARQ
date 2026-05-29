//
//  InterchangeSheetView.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import SwiftUI

struct InterchangeSheetView: View {
    
    @Binding var mainCurrency: String
    
    @Binding var selectedCurrency: String
    
    var currencies: [String]
    
    @StateObject var vm = InterchangeSheetViewModel()
    
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
                        .foregroundStyle(.black)
                }
                
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 16)
            
            VStack(spacing: 0) {
                
                ForEach(vm.currencyList(currencies, mainCurrency), id: \.self) { currency in
                    
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
