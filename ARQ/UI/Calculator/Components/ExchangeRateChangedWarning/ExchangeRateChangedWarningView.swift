//
//  ExchangeRateChangedWarningView.swift
//  ARQ
//
//  Created by rafael on 31/05/26.
//

import SwiftUI

struct ExchangeRateChangedWarningView: View {
    
    @StateObject var vm = ExchangeRateChangedWarningViewModel()
    
    let show: Bool
    
    var body: some View {
        if show {
            VStack {
                Text(vm.exchangeRateChangedWarning)
                    .defaultFont(size: 14, weight: .semiBold)
                
                Spacer()
                    .frame(height: 8)
                
                Text(vm.exchangeRateChangedWarningHelp)
                    .defaultFont(size: 12, weight: .semiBold)
            }
            .padding(.top, show ? 15 : 0)
            .foregroundStyle(.gray)
            .opacity(vm.opacity)
            .onAppear { vm.startPulsing() }
            .onDisappear { vm.stopPulsing() }
        }
    }
}
