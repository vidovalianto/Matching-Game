//
//  GameViewController.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/1/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation
import UIKit

final class GameViewController: UIViewController {
    private let networkManager = NetworkManager.shared
    private let imageCM = ImageCachingManager.shared
    private let productManager = ProductManager.shared

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
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [settingBtn]

        networkManager.loadCard().sink { products in
            DispatchQueue.main.async {
                self.productManager.products = products
                self.initCard(products: self.productManager.products)
                self.activityView.stopAnimating()
            }
        }.cancel()
        

    }

    private func initCard(products: Products) {
        let gridVC = GridViewController()

        DispatchQueue.main.async {
            gridVC.products = self.productManager.products.products
            self.add(gridVC)
        }
    }

    @objc
    private func gameSettings() {

    }


}
