//
//  WinningViewController.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/6/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

final class WinningViewController: UIViewController {
    private let gamePM = GamePlayManager.shared
    public var gridVC: GridViewController? = nil

    private lazy var settingsView: [[UIView]] = {
        return [[winLbl as UIView], [movesLbl as UIView], [restartBtn as UIView, continueBtn as UIView]]
    }()

    private let transparentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        return view
    }()

    fileprivate lazy var stackView: UIStackView = { [unowned self] in
        let views = self.settingsView.map { settings -> UIView in
            return UIStackView(views: settings, axis: .horizontal) as UIView
        }
        let stackView = UIStackView(views: views, axis: .vertical)
        stackView.backgroundColor = .systemBackground
        return stackView
    }()

    private lazy var movesLbl: UILabel = {
        let label = UILabel()
        label.text = "Moves \(self.gamePM.movesCount) times"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics(forTextStyle: .largeTitle)
            .scaledFont(for: UIFont(name: "AvenirNext-Medium",
                                    size: UIFont.labelFontSize) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
        return label
    }()

    private let winLbl: UILabel = {
        let label = UILabel()
        label.text = "You W I N"
        label.translatesAutoresizingMaskIntoConstraints = false
        guard let customFont = UIFont(name: "Carosello-Regular", size: 30) else {
            fatalError("""
                Failed to load the "Carosello-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: customFont)
        label.sizeToFit()
        return label
    }()

    private let restartBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Restart", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 10.0,
                                                left: 10.0,
                                                bottom: 10.0,
                                                right: 10.0)
        button.titleLabel?.font =  UIFontMetrics(forTextStyle: .headline)
            .scaledFont(for: UIFont(name: "AvenirNext-Regular",
                                    size: UIFont.labelFontSize) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
        return button
    }()

    private let continueBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.addTarget(self, action: #selector(continueGame), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 10.0,
                                              left: 10.0,
                                              bottom: 10.0,
                                              right: 10.0)
        button.titleLabel?.font =  UIFontMetrics(forTextStyle: .headline)
            .scaledFont(for: UIFont(name: "AvenirNext-Regular",
                                    size: UIFont.labelFontSize) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
        return button
    }()

    private lazy var confettiLayer: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: 300)
        emitter.emitterShape = .rectangle
        emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        emitter.emitterCells = confettiCells
        return emitter
    }()

    private let confettiCells: [CAEmitterCell] = {
        return [0.50].map { _ in
            let cell = CAEmitterCell()
            cell.birthRate = 4.0
            cell.lifetime = 10.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(0.5)
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.8
            cell.color = .init(srgbRed: 0.93, green: 0.93, blue: 0, alpha: 1.0)
            cell.scaleRange = 0.5
            cell.scale = 0.1
            cell.contents = UIImage(named: "circle")?.cgImage
            return cell
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initConstraint()
    }

    private func initConstraint() {
        self.view.addSubview(transparentView)
        NSLayoutConstraint.activate([
            transparentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            transparentView.heightAnchor.constraint(equalToConstant: self.view.bounds.height/4),
            transparentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        transparentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: 50),
            stackView.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -50)
        ])

        self.view.layer.insertSublayer(confettiLayer, below: transparentView.layer)
    }

    @objc
    private func continueGame() {
        self.removeFromParent()
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    private func restartGame() {
        self.gamePM.reset()
        self.gridVC?.resetItems()
        self.gridVC?.shuffleCard()
        self.dismiss(animated: true, completion: nil)
    }
}

private extension UIStackView {
    convenience init(views: [UIView], axis: NSLayoutConstraint.Axis) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.distribution = .equalCentering
        self.alignment = UIStackView.Alignment.center
        self.spacing = 5
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
