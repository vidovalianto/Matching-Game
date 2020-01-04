//
//  ViewController.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/1/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import UIKit

final class DashboardViewController: UIViewController {
    private let startBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        button.backgroundColor = .brown
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initStartBtn()
    }

    private func initView() {
        self.view.addSubview(startBtn)
    }

    private func initStartBtn() {
        self.view.addSubview(startBtn)
        NSLayoutConstraint.activate([
            startBtn.heightAnchor.constraint(equalToConstant: 200),
            startBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            startBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            startBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor),
        ])
    }

    @objc
    private func startGame() {
        let gameVC = GameViewController()
        self.navigationController?.show(gameVC, sender: nil)
    }


}

