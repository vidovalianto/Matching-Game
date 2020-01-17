//
//  ProductImages.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/2/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

final class ProductImages: NSObject, Decodable, Identifiable {
    internal let id: Int
    public let imageURL: String
    public var isMatch = false
    public var clickIndex = [Int]()

    public init(id: Int,
                imageUrl: String) {
        self.id = id
        self.imageURL = imageUrl
    }

    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "src"
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.imageURL = try container.decode(String.self, forKey: .imageUrl)
    }
}

