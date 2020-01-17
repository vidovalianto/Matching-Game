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
    private var winCancellable: AnyCancellable?
    private var gridCancellable: AnyCancellable?

    private let gridVC: GridViewController = {
        return GridViewController()
    }()

    private let playerPointLbl: UILabel = {
        let label = UILabel()
        label.text = "Points: 0"
        label.textColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.font = UIFontMetrics(forTextStyle: .headline)
            .scaledFont(for: UIFont(name: "AvenirNext-Medium",
                                    size: UIFont.labelFontSize) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
        return label
    }()

    private lazy var settingBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "gear"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(gameSettings))
        return button
    }()

    private lazy var shuffleBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "repeat"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(shuffleCard))
        return button
    }()

    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.color = .systemGray6
        activityView.center = self.view.center
        activityView.startAnimating()
        return activityView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityView)

        self.view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItems = [settingBtn, shuffleBtn]

        cardCancellable = networkManager.loadCard().sink { products in
            DispatchQueue.main.async {
                self.productManager.products = products
                self.initCard()
                self.activityView.stopAnimating()
            }
        }

        winCancellable = self.gamePM.isWinning.sink(receiveValue: {
            if $0 {
                DispatchQueue.main.async {
                    self.initWinningVC()
                }
            }
        })

        self.initPoints()
    }

    deinit {
        cardCancellable?.cancel()
        pointCancellable?.cancel()
        winCancellable?.cancel()
    }

    private func initPoints() {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sizeToFit()
        self.view.addSubview(view)
        view.addSubview(playerPointLbl)

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 50),
            view.widthAnchor.constraint(equalToConstant: 100),
            view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topbarHeight),
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            playerPointLbl.topAnchor.constraint(equalTo: view.topAnchor),
            playerPointLbl.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            playerPointLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        pointCancellable = gamePM.$foundPairs.sink { point in
            self.playerPointLbl.text = "Points:  \(point)"
        }
    }

    private func initCard() {
        let frame = CGRect(x: 0,
                           y: -( self.playerPointLbl.frame.height),
                           width: self.view.bounds.width,
                           height: self.view.bounds.height - self.topbarHeight );
        self.add(self.gridVC, frame: frame)
    }

    private func initWinningVC() {
        let winningVC = WinningViewController()
        winningVC.gridVC = gridVC
        self.present(winningVC, animated: true)
    }

    @objc
    private func gameSettings() {
        let settingsVC = SettingsViewController()
        self.present(settingsVC, animated: true)
    }

    @objc
    private func shuffleCard() {
        self.gridVC.resetItems()
        self.gridVC.shuffleCard()
        self.gamePM.reset()
    }
}
