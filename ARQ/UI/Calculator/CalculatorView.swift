//
//  CalculatorView.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

import SwiftUI

struct CalculatorView: View {
    
    // makeDefault(): Makes the API calls listed in the task description.
    // makeMock(SECONDS): It simulates an API call and uses fake data.
    @StateObject var vm = CalculatorViewModel.makeMock(3)
    
    var body: some View {
        
        VStack {
            
            Group {
                HStack {
                    Text(vm.title)
                        .defaultFont(size: 30, weight: .bold)
                    Spacer()
                }
                .padding(.top, UIScreen.main.bounds.height * 0.15)
                
                Spacer()
                    .frame(height: 8)
                
                HStack {
                    Text(vm.currentPriceInformation)
                        .defaultFont(weight: .semiBold)
                        .foregroundStyle(.brand)
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
                .frame(height: 30)
            
            ZStack {
                
                VStack(spacing: 15) {
                    
                    CurrencyFieldView(
                        value: $vm.mainCurrencyValue,
                        currency: $vm.mainCurrency,
                        active: vm.mainFieldActive,
                        interchangeableAction: nil,
                        onFocus: vm.setMainFieldActive,
                    )
                    .onChange(of: vm.mainCurrencyValue, vm.onMainCurrencyValueChange)
                    
                    CurrencyFieldView(
                        value: $vm.secondaryCurrencyValue,
                        currency: $vm.secondaryCurrency,
                        active: vm.secondaryFieldActive,
                        interchangeableAction: vm.interchangeableButtonAction,
                        onFocus: vm.setSecondaryFieldActive
                    )
                    .onChange(of: vm.secondaryCurrencyValue, vm.onSecondaryCurrencyValueChange)
                    
                }
                .padding(.horizontal, 16)
                
                SwappableButtonView(
                    disabled: vm.isAnyCurrencyNotSelected,
                    swappableAction: vm.swapButtonAction,
                    disabledAction: vm.interchangeableButtonAction
                )
            }
            .task {
                await vm.loadData()
                vm.startPolling()
            }
            
            ErrorWarningView(message: vm.errorMessage, show: vm.somethingGoneWrong, retryAction: vm.retryButtonAction)
            
            ExchangeRateChangedWarningView(show: vm.showExchangeRateChangedWarning)
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    vm.onEmptyAreaClickAction()
                }
        }
        .sheet(isPresented: $vm.showInterchangeSheet) {
            InterchangeSheetView(
                mainCurrency: $vm.mainCurrency,
                selectedCurrency: $vm.secondaryCurrency,
                currencies: vm.availableCurrencies,
                error: vm.somethingGoneWrong,
                onDismiss: vm.onDismissSheetAction,
            ) { currency in
                vm.interchangeCurrency(currency)
            }
            .presentationDetents([.medium, .fraction(0.8)])
            .presentationCornerRadius(50)
            .presentationBackground(.stockBackground)
        }
    }
}
