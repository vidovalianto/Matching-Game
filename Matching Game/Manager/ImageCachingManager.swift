//
//  ImageCachingManager.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/2/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import Foundation
import UIKit

final class ImageCachingManager {
    static let shared = ImageCachingManager()
    private let networkManager = NetworkManager.shared
    private lazy var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = config.countLimit
        return cache
    }()

    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()


    private let config: Config

    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(countLimit: 100,
                                          memoryLimit: 1024 * 1024 * 100)
    }

    private init(config: Config = Config.defaultConfig) {
        self.config = config
    }

    public func loadImage(url: URL) -> AnyPublisher<UIImage?, Never> {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            return Just(cachedImage).eraseToAnyPublisher()
        } else {
            let cancellable = networkManager.loadImage(url: url, queue: backgroundQueue)
            let _ = cancellable.sink { if let image = $0 {
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                }
            }.cancel()
            return cancellable
        }
    }
}
