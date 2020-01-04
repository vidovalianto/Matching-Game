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

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum APIClientError: Error {
    case noData, noUrl
}

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

    public func loadImage(url: URL, queue: OperationQueue) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, _) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .subscribe(on: queue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

//    public func getCard(completion: @escaping ((Result<Products>) -> Void)) {
//        let defaultSession = URLSession(configuration: .default)
//        var dataTask: URLSessionDataTask?
//        dataTask?.cancel()
//
//        if var urlComponents = URLComponents(string: baseURl) {
//          guard let url = urlComponents.url else {
//            completion(.failure(APIClientError.noUrl))
//            return
//          }
//          dataTask =
//            defaultSession.dataTask(with: url) { [weak self] data, response, error in
//            defer {
//              dataTask = nil
//            }
//            if let error = error {
//              self?.errorMessage += "DataTask error: " +
//                                      error.localizedDescription + "\n"
//            } else if
//              let data = data,
//              let response = response as? HTTPURLResponse,
//              response.statusCode == 200 {
//                let decoder = JSONDecoder()
//                do {
//                    let products = try decoder.decode(Products.self, from: data)
//                    completion(.success(products))
//
//                } catch {
//                    print(error)
//                }
//              DispatchQueue.main.async {
//
//              }
//            }
//          }
//          // 7
//          dataTask?.resume()
//        }
//    }

//    public func downloadImage(url: String, completion: @escaping ((Result<UIImage?>) -> Void)) {
//            let defaultSession = URLSession(configuration: .default)
//            var dataTask: URLSessionDataTask?
//            dataTask?.cancel()
//
//            if var urlComponents = URLComponents(string: url) {
//              guard let url = urlComponents.url else {
//                completion(.failure(APIClientError.noUrl))
//                return
//              }
//              dataTask =
//                defaultSession.dataTask(with: url) { [weak self] data, response, error in
//                defer {
//                  dataTask = nil
//                }
//                if let error = error {
//                  self?.errorMessage += "DataTask error: " +
//                                          error.localizedDescription + "\n"
//                } else if
//                  let data = data,
//                  let response = response as? HTTPURLResponse,
//                  response.statusCode == 200 {
//                    DispatchQueue.main.async {
//                        let image = UIImage(data: data)
//                        completion(.success(image))
//                    }
//                }
//              }
//              // 7
//              dataTask?.resume()
//            }
//        }
}
