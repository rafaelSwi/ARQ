//
//  CalculatorView.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

import SwiftUI

struct CalculatorView: View {
    
    @StateObject var vm = CalculatorViewModel()
    
    
    var body: some View {
        Text(vm.title)
            .defaultFont(size: 30, weight: .semiBold)
        
        VStack {
            
            CurrencyFieldView(input: $vm.mainInput, currency: $vm.mainCurrency, swappable: true)
            
        }
        .padding(.horizontal, 16)
    }
}
