//
//  ExchangeRatesResponseDTO.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

struct ExchangeRatesResponseDTO: Decodable {
    let payload: [ExchangeRateDTO]
}

struct ExchangeRateDTO: Decodable {
    let ask: String?
    let bid: String?
    let book: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case ask, bid, book
        case updatedAt = "updated_at"
    }

    func toDomain() -> ExchangeRates {
        ExchangeRates(
            ask: Double(ask ?? ""),
            bid: Double(bid ?? ""),
            book: book,
            date: updatedAt?.asDate()
        )
    }
}
