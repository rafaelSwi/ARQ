//
//  VibrationUtils.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import UIKit

final class VibrationUtils {
    
    static func softVibrate() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
}
