//
//  SelectionIconView.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

import SwiftUI

struct SelectionIconView: View {
    
    @StateObject var vm = SelectionIconViewModel()
    
    let selected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(
                    selected ? Color.green : Color(.systemGray3),
                    lineWidth: 2
                )
                .frame(width: 26, height: 26)
            
            if selected {
                Circle()
                    .fill(Color.green)
                    .frame(width: 26, height: 26)
                
                Image(systemName: vm.selectedIcon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.stockButton)
            }
        }
    }
}
