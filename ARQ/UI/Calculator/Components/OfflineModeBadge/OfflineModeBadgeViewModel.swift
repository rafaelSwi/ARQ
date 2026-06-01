//
//  OfflineModeBadgeViewModel.swift
//  ARQ
//
//  Created by rafael on 01/06/26.
//

import Combine
import SwiftUI

@MainActor
final class OfflineModeBadgeViewModel: ObservableObject {
    
    let icon: String = "wifi.slash"
    
    let label: LocalizedStringKey = "offline_mode_message"
    
}
