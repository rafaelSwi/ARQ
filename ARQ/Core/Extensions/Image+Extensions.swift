//
//  Image+Extensions.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import SwiftUI

extension Image {
    
    func resizeSystemImage(width: CGFloat, height: CGFloat) -> some View {
        return self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
    
}
