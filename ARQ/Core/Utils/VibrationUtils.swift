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
    
    static func deniabilityVibrate() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        
        let delays: [Double] = [0, 0.08, 0.16]
        for delay in delays {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                generator.impactOccurred()
            }
        }
    }
    
}
