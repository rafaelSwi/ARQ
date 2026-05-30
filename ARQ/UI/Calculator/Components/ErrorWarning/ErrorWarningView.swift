//
//  ErrorWarningView.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

import SwiftUI

struct ErrorWarningView: View {
    
    @StateObject var vm = ErrorWarningViewModel()
    
    let message: String?
    
    let retryAction: (() async -> Void)
    
    var body: some View {
        
        Button(vm.retryButtonLabel) {
            Task {
                await retryAction()
            }
        }
        .defaultFont()
        .foregroundStyle(.primary)
        .padding(10)
        .background(.stockButton)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
        Text(message?.localized ?? "")
            .defaultFont(size: 11)
            .foregroundStyle(.red)
            .lineLimit(2)
            .padding(.top, 5)
    }
}
