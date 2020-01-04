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

    private init() {}

    public var foundPairs = CurrentValueSubject<Int,Never>(0)

    public var numOfMatch = CurrentValueSubject<Int,Never>(2)

    public var numOfGrid = CurrentValueSubject<Int,Never>(3)

    public var selectedItemsIndex = [IndexPath]()
    public var selectedItem: Int? 

    private let pairsToWin = 10


}
