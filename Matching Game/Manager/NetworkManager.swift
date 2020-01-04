//
//  NetworkManager.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/2/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import Foundation
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()

    private let method: String = "GET"
    private let baseURL: URL = URL(string: "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")!
    private var errorMessage = ""

    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    private init() {}

    public func loadCard() -> AnyPublisher<Products, Never> {
        return URLSession.shared.dataTaskPublisher(for: self.baseURL)
            .map { $0.data }
            .decode(type: Products.self, decoder: JSONDecoder())
            .replaceError(with: Products(products: [Product]()))
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    public func loadImage(url: URL,
                          queue: OperationQueue) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, _) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .subscribe(on: queue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
