//
//  OfflineModeBadgeView.swift
//  ARQ
//
//  Created by rafael on 01/06/26.
//

import SwiftUI

struct OfflineModeBadgeView: View {
    
    @StateObject var vm = OfflineModeBadgeViewModel()
    
    let show: Bool
    
    var body: some View {
        if show {
            HStack(spacing: 7) {
                Image(systemName: vm.icon)
                    .font(.caption2)
                Text(vm.label)
                    .defaultFont(size: 12)
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial, in: Capsule())
            .padding(.top, 15)
        }
    }
}
