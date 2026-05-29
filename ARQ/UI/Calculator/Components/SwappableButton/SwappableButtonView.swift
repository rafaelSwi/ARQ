//
//  SwappableButtonView.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import SwiftUI

struct SwappableButtonView: View {
    
    @StateObject var vm = SwappableButtonViewModel()
    
    let swappableAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            
            Circle()
                .foregroundStyle(.stockBackground)
                .frame(width: vm.backCircleSize, height: vm.backCircleSize)
            
            Circle()
                .foregroundStyle(.brand)
                .frame(width: vm.greenCircleSize, height: vm.greenCircleSize)
            
            Image(systemName: vm.arrowDownIcon)
                .resizeSystemImage(width: vm.arrowIconSize, height: vm.arrowIconSize)
                .foregroundStyle(.background)
                .fontWeight(.heavy)
        }
        .onTapGesture {
            VibrationUtils.softVibrate()
            swappableAction?()
        }
    }
}
