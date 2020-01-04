//
//  Products.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/2/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

final class Products: NSObject, Decodable, Identifiable {
    internal let products: [Product]

    enum CodingKeys: String, CodingKey {
        case products
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.products = try container.decode([Product].self, forKey: .products)
    }

    public init(products: [Product]) {
        self.products = products
    }
}
