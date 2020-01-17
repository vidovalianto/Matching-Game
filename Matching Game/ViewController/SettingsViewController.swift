//
//  SettingsViewController.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/5/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation
import UIKit

final class SettingsViewController: UIViewController {
    private let gamePM = GamePlayManager.shared

    private lazy var settingsView: [[UIView]] = {
        return [[gridLbl as UIView, gridTF as UIView],[matchLbl as UIView, matchTF as UIView]]
    }()

    fileprivate lazy var stackView: UIStackView = { [unowned self] in
        let views = self.settingsView.map { settings -> UIView in
            return UIStackView(views: settings, axis: .horizontal) as UIView
        }
        let stackView = UIStackView(views: views, axis: .vertical)
        return stackView
    }()

    private let gridLbl: UILabel = {
        let label = UILabel()
        label.text = "Grid Configuration"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var gridTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "\(self.gamePM.numOfGrid.value)"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .asciiCapableNumberPad
        return textField
    }()

    private let matchLbl: UILabel = {
        let label = UILabel()
        label.text = "Match Configuration"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var matchTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "\(self.gamePM.numOfMatch)"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .asciiCapableNumberPad
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.initConstraint()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let numofGrid = Int(self.gridTF.text ?? "3") {
            self.gamePM.numOfGrid.value = numofGrid
        }

        if let numofMatch = Int(self.matchTF.text ?? "2") {
            self.gamePM.numOfMatch = numofMatch
        }
    }

    private func initConstraint() {
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 10),
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 10),
            stackView.heightAnchor.constraint(equalToConstant: self.view.bounds.height/10)
        ])
    }
}

private extension UIStackView {
    convenience init(views: [UIView], axis: NSLayoutConstraint.Axis) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.distribution = UIStackView.Distribution.fillEqually
        self.alignment = UIStackView.Alignment.fill
        self.spacing = 5
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
}
