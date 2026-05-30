//
//  SwappableButtonView.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import SwiftUI

struct SwappableButtonView: View {
    
    @StateObject var vm = SwappableButtonViewModel()
    
    let disabled: Bool
    
    let swappableAction: (() -> Void)?
    
    let disabledAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            
            Circle()
                .foregroundStyle(.stockBackground)
                .frame(width: vm.backCircleSize, height: vm.backCircleSize)
            
            Circle()
                .foregroundStyle(.brand)
                .frame(width: vm.greenCircleSize, height: vm.greenCircleSize)
            
            Image(systemName: disabled ? vm.disabledIcon : vm.arrowDownIcon)
                .resizeSystemImage(width: vm.iconSize(disabled), height: vm.iconSize(disabled))
                .foregroundStyle(.background)
                .fontWeight(.heavy)
        }
        .onTapGesture {
            if disabled {
                disabledAction?()
            } else {
                swappableAction?()
            }
        }
    }
}
