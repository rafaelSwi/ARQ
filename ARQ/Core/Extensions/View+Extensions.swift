//
//  View+Extensions.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

import SwiftUI

extension View {
    
    func defaultFont(size: Int = 16) -> some View {
        return self
            .font(Font.custom(CustomFonts.messinaSansBold.rawValue, size: CGFloat(size), relativeTo: .title))
    }
    
}
