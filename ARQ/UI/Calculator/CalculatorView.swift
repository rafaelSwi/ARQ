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
        
        VStack {
            
            Text(vm.title)
                .defaultFont(size: 30, weight: .semiBold)
            
            ZStack {
                
                VStack(spacing: 15) {
                    
                    CurrencyFieldView(
                        input: $vm.mainInput,
                        currency: $vm.mainCurrency,
                        interchangeableAction: nil
                    )
                    
                    CurrencyFieldView(
                        input: $vm.secondaryInput,
                        currency: $vm.secondaryCurrency
                    ) {
                        vm.interchangeableButtonAction()
                    }
                    
                }
                .padding(.horizontal, 16)
                
                SwappableButtonView() {
                    vm.swap()
                }
            }
            .task {
                await vm.loadData()
            }
            
            Text(vm.errorMessage ?? "no_error_at_the_moment") // TODO: REMOVE
                .bold()
                .foregroundStyle(.brown)
                .padding(.top, 15)
        }
        .sheet(isPresented: $vm.showInterchangeSheet) {
            InterchangeSheetView(
                mainCurrency: $vm.mainCurrency,
                selectedCurrency: $vm.secondaryCurrency,
                currencies: $vm.currencies,
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
