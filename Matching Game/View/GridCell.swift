//
//  GridCell.swift
//  Matching Game
//
//  Created by Vido Valianto on 1/3/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import UIKit

class GridCell: UICollectionViewCell {
    static let reuseIdentifier = "grid-cell"
    public var productImages: ProductImages?
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?

    public let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .tertiarySystemFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public let backgroundImage: UIImageView = {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFit
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImage
    }()

    public let foregroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.secondarySystemFill.cgColor
        view.layer.borderWidth = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public let foregroundImage: UIImageView = {
        let foregroundImage = UIImageView(frame: UIScreen.main.bounds)
        foregroundImage.contentMode = UIView.ContentMode.scaleToFill
        foregroundImage.translatesAutoresizingMaskIntoConstraints = false
        return foregroundImage
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImage.image = nil
        backgroundImage.alpha = 0.0

        foregroundImage.image = nil
        foregroundImage.alpha = 0.0

        animator?.stopAnimation(true)
        cancellable?.cancel()
    }

    public func configureData(productImages: ProductImages) {
        cancellable = loadImage(productImages: productImages).sink { [unowned self] image in
            DispatchQueue.main.async {
                self.showImage(image: image)
            }
        }
    }

    private func showImage(image: UIImage?) {
        backgroundImage.alpha = 0.0
        foregroundImage.alpha = 0.0
        animator?.stopAnimation(false)
        backgroundImage.image = image
        foregroundImage.image = UIImage(named: "shopify")
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3,
                                                                  delay: 0,
                                                                  options: .curveLinear,
                                                                  animations: {
            self.backgroundImage.alpha = 1.0
            self.foregroundImage.alpha = 1.0
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animator?.stopAnimation(true)
            self.animator?.finishAnimation(at: .current)
        }
    }

    private func loadImage(productImages: ProductImages) -> AnyPublisher<UIImage?, Never> {
        return Just(productImages.imageURL)
        .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
            let url = URL(string: productImages.imageURL)!
            return ImageCachingManager.shared.loadImage(url: url)
        })
        .eraseToAnyPublisher()
    }
}

extension GridCell {
    public func configure() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.addSubview(cardView)
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: inset),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -inset),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                          constant: inset),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -inset),
        ])

        cardView.addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: cardView.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])

        cardView.addSubview(foregroundView)
        NSLayoutConstraint.activate([
            foregroundView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            foregroundView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            foregroundView.topAnchor.constraint(equalTo: cardView.topAnchor),
            foregroundView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])

        foregroundView.addSubview(foregroundImage)
        NSLayoutConstraint.activate([
            foregroundImage.leadingAnchor.constraint(equalTo: foregroundView.leadingAnchor),
            foregroundImage.trailingAnchor.constraint(equalTo: foregroundView.trailingAnchor),
            foregroundImage.topAnchor.constraint(equalTo: foregroundView.topAnchor),
            foregroundImage.bottomAnchor.constraint(equalTo: foregroundView.bottomAnchor)
        ])
    }
}
