//
//  MockExchangeRatesRepository.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

final class MockExchangeRatesRepository: ExchangeRatesRepositoryProtocol {
    
    let fakeDelayInSeconds: Int
    
    init(fakeDelayInSeconds: Int) {
        self.fakeDelayInSeconds = fakeDelayInSeconds
    }
    
    func fetchExchangeRates(currencies: [String]) async throws -> [ExchangeRates] {
        try await Task.sleep(for: .seconds(fakeDelayInSeconds))
        
        let all = [
            ExchangeRates(ask: 1, bid: 1, book: "usdc_usdc", date: nil),
            ExchangeRates(ask: 18.41, bid: 18.40, book: "usdc_mxn", date: "2025-10-20T20:14:57.361483956".asDate()),
            ExchangeRates(ask: 1551.00, bid: 1539.43, book: "usdc_ars", date: "2025-10-21T09:44:18.512194175".asDate()),
            ExchangeRates(ask: 0.8597, bid: 0.8590, book: "usdc_eurc", date: "2025-10-21T09:44:18.512194175".asDate()),
            ExchangeRates(ask: 3771.27, bid: 3768.00, book: "usdc_cop", date: "2025-10-21T09:44:18.512194175".asDate()),
            ExchangeRates(ask: 5.23, bid: 5.21, book: "usdc_brl", date: "2025-10-21T09:44:18.512194175".asDate())
        ]
        .map { rate in
            guard rate.book != "usdc_usdc", let ask = rate.ask, let bid = rate.bid else {
                return rate
            }
            let variance = Double.random(in: -0.02...0.02)
            return ExchangeRates(
                ask: (ask * (1 + variance) * 10000).rounded() / 10000,
                bid: (bid * (1 + variance) * 10000).rounded() / 10000,
                book: rate.book,
                date: rate.date
            )
        }
        
        return all.filter { rate in
            guard let book = rate.book else { return false }
            return currencies.contains { book.hasSuffix($0.lowercased()) }
        }
    }
    
}
