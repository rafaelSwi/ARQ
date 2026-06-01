//
//  ExchangeRates.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

import Foundation

struct ExchangeRates: Codable {
    var ask: Double?
    var bid: Double?
    let book: String?
    var date: Date?
}
