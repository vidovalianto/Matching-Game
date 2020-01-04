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

    private var col: Int = 3
    private var cancellable: AnyCancellable?

    public var productImages = [ProductImages]() {
        didSet {
            self.items = Array(Array(repeating: Array(productImages[0...5]),
                                     count: self.gamePM.numOfMatch.value).joined())
        }
    }

    public var products = [Product]() {
        didSet {
            self.productImages = self.products.compactMap { product -> ProductImages? in
                return product.images.first
            }
        }
    }

    private var items = [ProductImages]()

    private let sections = [Section.main]

    convenience init(col: Int? = 3) {
        self.init()
        if let col = col {
            self.col = col
        }
    }

    enum Section: String {
        case main = "Main"
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        cancellable = self.productManager.$products.sink { self.products = $0.products }
    }

    deinit {
        cancellable?.cancel()
    }
}

extension GridViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(col)),
                                              heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.3))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)

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
            cell.contentView.backgroundColor = .white
            cell.configureData(productImages: self.items[identifier])

            // Return the cell.
            return cell
        }

        dataSource.apply(createDuplicate(), animatingDifferences: false)
    }

    private func createDuplicate() -> NSDiffableDataSourceSnapshot
        <Section, Int> {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()

            for section in sections {
                snapshot.appendSections([section])
                snapshot.appendItems(Array(0...items.count-1))
            }
            return snapshot
    }
}

extension GridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath[1], self.items[indexPath[1]].id)

        if self.gamePM.selectedItem != self.items[indexPath[1]].id {
            print("dif")
            self.gamePM.selectedItemsIndex = [IndexPath]()
            self.gamePM.selectedItem = self.items[indexPath[1]].id
        }
        self.gamePM.selectedItemsIndex.append(indexPath)

        if self.gamePM.selectedItemsIndex.count == self.gamePM.numOfMatch.value {
            self.gamePM.foundPairs.send(self.gamePM.foundPairs.value+1)
            print("match")

            self.gamePM.selectedItemsIndex.map { index in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.reuseIdentifier, for: index) as! GridCell
                cell.contentView.isHidden = true
                print(cell,index)
            }

            self.gamePM.selectedItemsIndex = [IndexPath]()
        }

        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
