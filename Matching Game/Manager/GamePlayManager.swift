//
//  GamePlayManager.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/4/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import Foundation

final class GamePlayManager: ObservableObject {
    static let shared = GamePlayManager()

    private init() { }

    @Published
    public var numOfMatch: Int = 2 {
        didSet {
            self.reset()
        }
    }

    @Published
    public var foundPairs: Int = 0 {
        didSet {
            if self.foundPairs == self.matchToWin {
                self.isWinning.value = true
            }
        }
    }

    public var isWinning = CurrentValueSubject<Bool,Never>(false)
    public var numOfGrid = CurrentValueSubject<Int,Never>(3)

    public var selectedItemsIndex = [IndexPath]()
    public var selectedItemId: Int?
    public var movesCount = 0
    public var isSelecting = false

    private let matchToWin = 3

    public func reset() {
        self.isWinning.value = false
        self.foundPairs = 0
        self.movesCount = 0
        self.selectedItemId = nil
        self.selectedItemsIndex = [IndexPath]()
        self.isSelecting = false
    }


}
