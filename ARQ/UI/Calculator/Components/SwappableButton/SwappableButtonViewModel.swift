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
    let arrowIconSize: CGFloat = 12
    let greenCircleSize: CGFloat = 28
    
    var backCircleSize: CGFloat {
        return greenCircleSize + (greenCircleSize * 0.5)
    }
    
}
