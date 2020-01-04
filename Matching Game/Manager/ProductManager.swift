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

    private init() { }

    @Published
    public var products: Products = Products(products: [Product]()) 
}
