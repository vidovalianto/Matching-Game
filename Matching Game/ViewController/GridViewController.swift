//
//  GridViewController.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/3/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation
import SwiftUI

final class GridViewController: UIViewController {
    private let productManager = ProductManager.shared
    private var col: Int = 3
    public var productImages = [ProductImages]()
    public var products = [Product]() {
        didSet {
            self.productImages = self.products.compactMap { product -> ProductImages? in
                return product.images.first
            }
            self.imageLoaded()
        }
    }
    let sections = [Section.main]

    convenience init(col: Int? = 3) {
        self.init()
        if let col = col {
            self.col = col
        }
    }

    enum Section: String {
        case main = "Main"
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, ProductImages>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        self.productManager.$products.sink { self.products = $0.products }.cancel()
        
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
        dataSource = UICollectionViewDiffableDataSource<Section, ProductImages>(collectionView: collectionView)
        { (collectionView: UICollectionView, indexPath: IndexPath, identifier: ProductImages)
            -> UICollectionViewCell? in
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GridCell.reuseIdentifier,
                for: indexPath) as? GridCell else { fatalError("Could not create new cell") }

            // Populate the cell with our item description.
            cell.contentView.backgroundColor = .white
            cell.configureData(productImages: identifier)

            // Return the cell.
            return cell
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductImages>()

        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(productImages)
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func randomizeSnapshot() -> NSDiffableDataSourceSnapshot
        <Section, ProductImages> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductImages>()
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(productImages)
            
        }
        return snapshot
    }


}

extension GridViewController {
    func imageLoaded() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductImages>()
        snapshot.appendSections([Section.main])
        print(self.productImages.count)
        snapshot.appendItems(productImages, toSection: Section.main)
//        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension GridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath[1], productImages[indexPath[1]].id)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
