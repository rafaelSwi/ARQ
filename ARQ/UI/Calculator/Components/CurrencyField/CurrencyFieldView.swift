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
    
    let swappable: Bool
    
    @StateObject var vm = CurrencyFieldViewModel()
    
    var body: some View {
        HStack {
            
            vm.currencyIcon(currency)
                .frame(width: 16, height: 16)
            
            Group {
                
                Text(vm.currencyName(currency))
                
                if swappable {
                    Image("ui_arrow_down")
                        .frame(width: 12, height: 12)
                        .offset(y: 2)
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
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
    }
}
