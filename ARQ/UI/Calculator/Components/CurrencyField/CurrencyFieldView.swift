//
//  CurrencyFieldView.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import SwiftUI

struct CurrencyFieldView: View {
    
    @Binding var input: String
    
    @Binding var currency: String
    
    let interchangeableAction: (() -> Void)?
    
    @StateObject var vm = CurrencyFieldViewModel()
    
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
                
                TextField(vm.amountFieldTitle, text: $input)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: input) { // TODO: CHECK THIS
                        vm.persistMoneySymbol($input, newValue: input)
                    }
                
            }
            .defaultFont(weight: .semiBold)
            
        }
        .padding(vm.clipPadding)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: vm.clipCornerRadius))
        
    }
}
