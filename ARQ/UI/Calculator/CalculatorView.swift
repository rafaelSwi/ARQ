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
        Text("exchange_calculator_title")
            .defaultFont(size: 30)
    }
}
