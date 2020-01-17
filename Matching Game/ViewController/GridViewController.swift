//
//  GridViewController.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/3/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

final class GridViewController: UIViewController {
    private let productManager = ProductManager.shared
    private let gamePM = GamePlayManager.shared

    public lazy var col: Int = gamePM.numOfGrid.value

    private var cancellable: AnyCancellable?
    private var gridCancellable: AnyCancellable?
    private var itemsCancellable: AnyCancellable?

    private let sections = [Section.main]

    public var items = [ProductImages]() {
        didSet {
            self.items.shuffle()
        }
    }

    convenience init(col: Int? = 3) {
        self.init()
        if let col = col {
            self.col = col
        }
    }

    enum Section: String {
        case main = "Main"
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    public var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        gridCancellable = self.gamePM.numOfGrid.sink(receiveValue: {
            self.col = $0
            if let collectionView = self.collectionView {
                collectionView.setCollectionViewLayout(self.createLayout(),
                                                       animated: true)
            }

        })

        itemsCancellable = self.productManager.items.sink(receiveValue: { items in
            self.resetItems()
            self.items = items
            DispatchQueue.main.async {
                self.dataSource.apply(self.createSnapshot(),
                                      animatingDifferences: true)
            }
        })

        configureHierarchy()
        configureDataSource()
    }

    deinit {
        cancellable?.cancel()
        gridCancellable?.cancel()
        itemsCancellable?.cancel()
    }
}

extension GridViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(col)),
                                              heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.4))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension GridViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GridCell.self,
                                forCellWithReuseIdentifier: GridCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView)
        { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int)
            -> UICollectionViewCell? in
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GridCell.reuseIdentifier,
                for: indexPath) as? GridCell else { fatalError("Could not create new cell") }

            // Populate the cell with our item description.
            cell.contentView.backgroundColor = .systemBackground

            if self.items.count > 0  && self.items.count > identifier {
                if !self.items[identifier].isMatch {
                    cell.configureData(productImages: self.items[identifier])
                    cell.foregroundView.alpha = self.items[identifier].clickIndex.contains(indexPath[1]) ? 0.0 : 1.0
                }

                cell.contentView.isHidden = self.items[identifier].isMatch
            }

            // Return the cell.
            return cell
        }

        dataSource.apply(createSnapshot(), animatingDifferences: true)
    }

    private func createSnapshot() -> NSDiffableDataSourceSnapshot
        <Section, Int> {
            self.collectionView.reloadData()
            let array = self.items.count > 1 ? Array(0...self.items.count-1) : [0]
            var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()

            for section in sections {
                snapshot.appendSections([section])
                snapshot.appendItems(array)
            }
            return snapshot
    }
}

extension GridViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.gamePM.movesCount += 1


        if !self.items[indexPath[1]].isMatch && !self.gamePM.selectedItemsIndex.contains(indexPath) {
            matchCheck(indexPath: indexPath)
            hideUnhideImage(index: indexPath[1])
            dataSource.apply(createSnapshot(), animatingDifferences: true)
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }

    private func hideUnhideImage(index: Int) {
        //hide / unhide foregroundimage
        if let clickindex = self.items[index].clickIndex.firstIndex(of: index) {
            self.items[index].clickIndex.remove(at: clickindex)
        } else {
            self.items[index].clickIndex.append(index)
        }
    }

    private func matchCheck(indexPath: IndexPath) {
        let index = indexPath[1]

        if !self.gamePM.isSelecting && self.gamePM.selectedItemId != nil {
            self.gamePM.selectedItemId = nil
            self.gamePM.selectedItemsIndex.forEach { indexPath in
                self.items[indexPath[1]].clickIndex.removeAll()
            }
            self.gamePM.selectedItemsIndex = [IndexPath]()
        }

        if self.gamePM.selectedItemId == self.items[index].id {
            self.gamePM.isSelecting = true
        } else if self.gamePM.selectedItemId == nil {
            self.gamePM.isSelecting = true
            self.gamePM.selectedItemId = self.items[index].id
        } else {
            self.gamePM.isSelecting = false
        }

        self.gamePM.selectedItemsIndex.append(indexPath)

        if self.gamePM.selectedItemsIndex.count == self.gamePM.numOfMatch && self.gamePM.isSelecting {
            self.gamePM.foundPairs = self.gamePM.foundPairs+1
            self.items[index].isMatch = true
            self.gamePM.selectedItemsIndex = [IndexPath]()
            self.gamePM.selectedItemId = nil
            self.gamePM.isSelecting = false
        }
    }
}

extension GridViewController {
    public func shuffleCard() {
        self.items.shuffle()
        self.dataSource.apply(createSnapshot(), animatingDifferences: true)
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
    }

    public func resetItems() {
        self.items.forEach( {
            $0.isMatch = false
            $0.clickIndex = [Int]()
        })
    }
}
