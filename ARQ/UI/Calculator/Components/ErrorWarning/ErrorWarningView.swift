//
//  ErrorWarningView.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

import SwiftUI

struct ErrorWarningView: View {
    
    @StateObject var vm = ErrorWarningViewModel()
    
    @Binding var offlineMode: Bool
    
    let message: String?
    let show: Bool
    let hasSavedData: Bool
    let retryAction: (() async -> Void)
    
    var body: some View {
        VStack {
            if show {
                if hasSavedData {
                    Text(vm.errorLabel)
                        .defaultFont(weight: .semiBold)
                        .foregroundStyle(.red)
                        .padding(10)
                        .background(.stockButton)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.bottom, 5)
                }
                
                Group {
                    Button(vm.retryButtonLabel) {
                        Task {
                            await retryAction()
                        }
                    }
                    
                    if hasSavedData {
                        Button(vm.offlineModeButtonLabel) {
                            offlineMode = true
                        }
                    }
                }
                .defaultFont()
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                
                Text(message?.localized ?? "")
                    .defaultFont(size: 11)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    .padding(.top, 5)
            }
        }
        .padding(.top, show ? 15 : 0)
    }
}
