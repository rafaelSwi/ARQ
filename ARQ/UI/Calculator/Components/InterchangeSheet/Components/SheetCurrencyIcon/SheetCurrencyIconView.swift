//
//  SheetCurrencyIconView.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

import SwiftUI

struct SheetCurrencyIconView: View {
    
    @StateObject var vm = SheetCurrencyIconViewModel()
    
    let currency: String
    
    var body: some View {
        Image(CurrencyUtils.currencyIconName(currency))
            .resizable()
            .scaledToFit()
            .frame(width: vm.imageSize, height: vm.imageSize)
        
        Text(CurrencyUtils.currencyName(currency))
            .defaultFont()
    }
}
