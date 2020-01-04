//
//  GameViewController.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/1/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import Foundation
import UIKit

final class GameViewController: UIViewController {
    private let gamePM = GamePlayManager.shared
    private let imageCM = ImageCachingManager.shared
    private let networkManager = NetworkManager.shared
    private let productManager = ProductManager.shared

    private var cardCancellable: AnyCancellable?
    private var pointCancellable: AnyCancellable?

    private let gridVC: GridViewController = {
        return GridViewController()
    }()

    private let playerPointLbl: UILabel = {
        let label = UILabel()
        label.text = "Points: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let settingBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .organize,
                        target: self,
                        action: #selector(gameSettings))
        return button
    }()

    private let shuffleBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add,
                        target: self,
                        action: #selector(gameSettings))
        return button
    }()

    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.color = .black
        activityView.center = self.view.center
        activityView.startAnimating()
        return activityView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityView)

        self.view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [settingBtn]

        cardCancellable = networkManager.loadCard().sink { products in
            DispatchQueue.main.async {
                self.productManager.products = products
                self.initCard(products: self.productManager.products)
                self.activityView.stopAnimating()
            }
        }

        self.initPoints()
    }

    deinit {
        pointCancellable?.cancel()
        cardCancellable?.cancel()
    }

    private func initPoints() {
        self.view.addSubview(playerPointLbl)

        NSLayoutConstraint.activate([
            playerPointLbl.heightAnchor.constraint(equalToConstant: 50),
            playerPointLbl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            playerPointLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

        pointCancellable = gamePM.foundPairs.sink { point in
            self.playerPointLbl.text = "Points:  \(point)"
        }
    }

    private func initCard(products: Products) {
        DispatchQueue.main.async {
            self.gridVC.products = self.productManager.products.products
            let height = self.navigationController?.navigationBar.bounds.size.height
            let frame = CGRect(x: 0,
                               y: -(height ?? self.topbarHeight),
                               width: self.view.bounds.width,
                               height: self.view.bounds.height - self.topbarHeight - self.playerPointLbl.frame.height*2);
            self.add(self.gridVC, frame: frame)
        }
    }

    @objc
    private func gameSettings() {

    }


}
