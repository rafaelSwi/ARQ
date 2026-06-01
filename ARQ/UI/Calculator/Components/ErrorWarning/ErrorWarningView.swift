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
    let show: Bool
    let retryAction: (() async -> Void)
    
    var body: some View {
        VStack {
            if show {
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
        .padding(.top, show ? 15 : 0)
    }
}
