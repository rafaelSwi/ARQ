//
//  View+Extensions.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

import SwiftUI

extension View {
    
    func defaultFont(size: Int = 16, weight: FontWeight = .regular) -> some View {
        
        var font: CustomFonts
        
        switch (weight) {
        case .regular: font = CustomFonts.messinaSans
        case .semiBold: font = CustomFonts.messinaSansSemiBold
        case .bold: font = CustomFonts.messinaSansBold
        }
        
        return self
            .font(Font.custom(font.rawValue, size: CGFloat(size), relativeTo: .title))
            .kerning(-0.5)
    }
    
    func appBackground() -> some View {
        return self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.stockBackground)
            .ignoresSafeArea()
    }
    
}
