//
//  ProductManager.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/4/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import Foundation

final class ProductManager: ObservableObject {
    static let shared = ProductManager()
    private var matchCancellable: AnyCancellable? 

    private init() {
        matchCancellable = GamePlayManager.shared.$numOfMatch.sink(receiveValue: {
            if !self.productImages.isEmpty {
                self.items.value = Array(Array(repeating: Array(self.productImages[0...5]),
                count: $0).joined())
            }
        })
    }

    public var products: [Product] = [] {
        didSet {
            self.productImages = self.products.map({ return $0.images.first! })
        }
    }

    @Published
    public var productImages = [ProductImages]() {
        didSet {
            self.items.value = Array(Array(repeating: Array(productImages[0...5]),
                                     count: GamePlayManager.shared.numOfMatch).joined())
        }
    }

    @Published
    public var items = CurrentValueSubject<[ProductImages],Never>([ProductImages]())

}
