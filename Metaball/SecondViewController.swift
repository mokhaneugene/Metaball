//
//  SecondViewController.swift
//  Metaball
//
//  Created by Eugene Mokhan on 16/09/2022.
//

import UIKit

final class SecondViewController: UIViewController {

    private let stackView = UIStackView()
    private let iconView = IconView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        setupItems()
    }
}

private extension SecondViewController {
    // MARK: - Private methods
    func setupItems() {
        setupIconView()
        setupStackView()
        setupButtons()
    }

    func setupIconView() {
        view.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 150.0),
            iconView.widthAnchor.constraint(equalToConstant: 150.0)
        ])
    }

    func setupStackView() {
        view.addSubview(stackView)
        stackView.spacing = 20.0
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        setupHorizontalStackView()
    }

    func setupHorizontalStackView() {
        let stackView = UIStackView()
        stackView.spacing = 10.0
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        self.stackView.addArrangedSubview(stackView)
    }

    func setupButtons() {
        
        for (index, iconName) in Constants.iconNames.enumerated() {
            if index % 4 == 0, index != 0 {
                setupHorizontalStackView()
            }
            var config = UIButton.Configuration.filled()
            config.image = UIImage(systemName: iconName)
            config.baseBackgroundColor = .white
            config.baseForegroundColor = .black

            let button = UIButton(configuration: config)
            button.addAction(
                .init(
                    handler: { [weak self] _ in
                        self?.iconView.update(with: UIImage(systemName: iconName))
                    }
                ),
                for: .touchUpInside)
            (stackView.arrangedSubviews.last as? UIStackView)?.addArrangedSubview(button)
        }
    }
}
