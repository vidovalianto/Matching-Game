//
//  Product.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/2/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

final class Product: NSObject, Decodable, Identifiable {
    internal let id: Int
    private let title: String
    public let images: [ProductImages]

    enum CodingKeys: String, CodingKey {
        case id, title, images
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.images = try container.decode([ProductImages].self, forKey: .images)
    }

    public init(id: Int,
                title: String,
                images: [ProductImages]) {
        self.id = id
        self.title = title
        self.images = images
    }
}
