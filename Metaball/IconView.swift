//
//  IconView.swift
//  Metaball
//
//  Created by Eugene Mokhan on 16/09/2022.
//

import UIKit

final class IconView: UIView {

    private let imageView = UIImageView()

    init() {
        super.init(frame: .zero)
        setupItems()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with image: UIImage?) {
//        let expandTransform = CGAffineTransform(scaleX: 1.15, y: 1.15)
//        UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve) { [weak self] in
//            self?.imageView.image = image
//            self?.imageView.transform = expandTransform
//        } completion: { _ in
//            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut) { [weak self] in
//                self?.imageView.transform = expandTransform.inverted()
//            }
//        }

        let expandTransform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve) { [weak self] in
            self?.imageView.image = image
            self?.imageView.transform = expandTransform
        } completion: { _ in
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut) { [weak self] in
                self?.imageView.transform = expandTransform.inverted()
            }
        }
    }
}

private extension IconView {
    // MARK: - Private methods
    func setupItems() {
        setupImageView()
    }

    func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50.0),
            imageView.widthAnchor.constraint(equalToConstant: 50.0)
        ])
    }
}
