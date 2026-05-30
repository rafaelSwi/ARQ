//
//  UsabilityUtils.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

import UIKit

final class UsabilityUtils {
    
    static func lowerKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
}
