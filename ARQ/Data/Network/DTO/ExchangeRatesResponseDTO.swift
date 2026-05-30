//
//  ExchangeRatesResponseDTO.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

struct ExchangeRateDTO: Decodable {
    let ask: String?
    let bid: String?
    let book: String?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case ask, bid, book, date
    }

    func toDomain() -> ExchangeRates {
        ExchangeRates(
            ask: Double(ask ?? ""),
            bid: Double(bid ?? ""),
            book: book,
            date: date?.asDate()
        )
    }
}
