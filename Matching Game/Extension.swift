//
//  Extension.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/3/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import UIKit

@nonobjc
extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)

        if let frame = frame {
            child.view.bounds = frame
        }

        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

extension Array where Element : Equatable {
    func allEqual() -> Bool {
        if let firstElem = first {
            return !dropFirst().contains { $0 != firstElem }
        }
        return true
    }
}
