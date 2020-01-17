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
        button.setTitleColor(.systemBackground, for: .normal)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        button.titleLabel?.font =  UIFontMetrics(forTextStyle: .headline)
            .scaledFont(for: UIFont(name: "AvenirNext-Regular",
                                    size: UIFont.labelFontSize) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
        return button
    }()

    private let titleLbl: UILabel = {
        let label = UILabel()
        label.text = "Robo \nMatch"
        label.translatesAutoresizingMaskIntoConstraints = false
        guard let customFont = UIFont(name: "Carosello-Regular", size: 100) else {
            fatalError("""
                Failed to load the "Carosello-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        label.adjustsFontForContentSizeCategory = true
        label.font = customFont
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var welcomeLbl: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the Game"
        label.font = UIFontMetrics(forTextStyle: .headline)
            .scaledFont(for: UIFont(name: "AvenirNext-UltraLight",
                                    size: UIFont.labelFontSize) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initStartBtn()
        self.initTitle()
        self.initWelcome()
    }

    private func initTitle() {
        self.view.addSubview(titleLbl)
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.welcomeLbl.bounds.height*2),
            titleLbl.bottomAnchor.constraint(equalTo: self.startBtn.topAnchor),
            titleLbl.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            titleLbl.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }

    private func initWelcome() {
        self.view.addSubview(welcomeLbl)
        NSLayoutConstraint.activate([
            welcomeLbl.heightAnchor.constraint(equalToConstant: 100),
            welcomeLbl.bottomAnchor.constraint(equalTo: self.startBtn.topAnchor, constant: self.welcomeLbl.bounds.height),
            welcomeLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }

    private func initStartBtn() {
        self.view.addSubview(startBtn)
        NSLayoutConstraint.activate([
            startBtn.heightAnchor.constraint(equalToConstant: 50),
            startBtn.widthAnchor.constraint(equalToConstant: 100),
            startBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.bounds.height/4),
            startBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }

    @objc
    private func startGame() {
        let gameVC = GameViewController()
        self.navigationController?.show(gameVC, sender: nil)
    }


}

