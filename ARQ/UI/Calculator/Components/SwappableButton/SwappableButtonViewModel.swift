//
//  SwappableButtonViewModel.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import Combine
import SwiftUI

@MainActor
final class SwappableButtonViewModel: ObservableObject {
    
    let arrowDownIcon: String = "arrow.down"
    let disabledIcon: String = "circle.fill"
    let greenCircleSize: CGFloat = 28
    
    func iconSize( _ disabled: Bool) -> CGFloat {
        return disabled ? 8 : 12
    }
    
    var backCircleSize: CGFloat {
        return greenCircleSize + (greenCircleSize * 0.5)
    }
    
}
