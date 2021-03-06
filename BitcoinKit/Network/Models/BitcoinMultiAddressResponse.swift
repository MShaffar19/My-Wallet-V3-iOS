//
//  BitcoinMultiAddressResponse.swift
//  BitcoinKit
//
//  Created by Alex McGregor on 5/8/20.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

public struct BitcoinMultiAddressResponse: Decodable {
    
    public let transactions: [BitcoinHistoricalTransaction]
    public let latestBlockHeight: Int
    
    enum RootCodingKeys: String, CodingKey {
        case txs
        case info
    }
    
    enum InfoCodingKeys: String, CodingKey {
        case latestBlock = "latest_block"
    }
    
    enum LatestBlockCodingKeys: String, CodingKey {
        case height
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: RootCodingKeys.self)
        let info = try values.nestedContainer(keyedBy: InfoCodingKeys.self, forKey: .info)
        let latestBlock = try info.nestedContainer(keyedBy: LatestBlockCodingKeys.self, forKey: .latestBlock)
        latestBlockHeight = try latestBlock.decode(Int.self, forKey: .height)
        transactions = try values.decode([BitcoinHistoricalTransaction].self, forKey: .txs)
        transactions.forEach { $0.apply(latestBlockHeight: latestBlockHeight) }
    }
}

