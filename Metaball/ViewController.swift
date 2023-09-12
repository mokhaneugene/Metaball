//
//  ViewController.swift
//  Metaball
//
//  Created by Eugene Mokhan on 15/08/2022.
//

import UIKit
import SpriteKit
import SceneKit

import CoreImage
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {

    private let stackView = UIStackView()

    private let skView = SKView()
    private let scene = SKScene()

    private var currentIcon: SKSpriteNode?

    private let filter = MetaballEffectFilter()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupItems()
        animateIconChange(newIconName: Constants.iconNames[0], duration: 0)
    }
}

private extension ViewController {
    // MARK: - Private methods
    func setupItems() {
        setupSKView()
        setupScene()
        setupStackView()
        setupButtons()
    }

    func setupSKView() {
        view.addSubview(skView)
        skView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            skView.topAnchor.constraint(equalTo: view.topAnchor),
            skView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            skView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupScene() {
        scene.filter = filter
        scene.scaleMode = .resizeFill
        scene.physicsWorld.gravity = .zero
        scene.shouldEnableEffects = true

        skView.presentScene(scene)
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
            button.addAction(.init(handler: { [weak self] _ in
                self?.animateIconChange(newIconName: iconName, duration: 0.5)
            }), for: .touchUpInside)
            (stackView.arrangedSubviews.last as? UIStackView)?.addArrangedSubview(button)
        }
    }

    func animateIconChange(newIconName: String, duration: CGFloat, showPlayIcon: Bool = false) {
        let iconSize = CGSize(width: 50, height: 50)

        guard let image = UIImage(systemName: newIconName)?.withTintColor(.white).resizeImageTo(size: iconSize) else { return }

        let texture = SKTexture(image: image)

        let newIconShape = SKSpriteNode(texture: texture, size: iconSize)
        newIconShape.position = view.center
        newIconShape.alpha = 0
        scene.addChild(newIconShape)

        let oldIconShape = currentIcon
        currentIcon = nil
        currentIcon = newIconShape

        if duration == 0 {
            newIconShape.alpha = 1
            oldIconShape?.removeFromParent()
            return
        }

        let fadeDuration = (duration * 0.25)

        // Animate in the blur effect
        animateBlur(duration: fadeDuration, blur: 5, from: 0)

        // Wait then start fading in the new icon and out the old
        DispatchQueue.main.asyncAfter(deadline: .now() + (fadeDuration * 0.75), execute: { [weak self] in
            let swapDuration = duration * 0.5
            newIconShape.run(SKAction.fadeAlpha(to: 1, duration: swapDuration))
            oldIconShape?.run(SKAction.fadeAlpha(to: 0, duration: swapDuration))

            // Wait, then start returning the view back to a non-blobby version
            DispatchQueue.main.asyncAfter(deadline: .now() + (swapDuration * 0.75), execute: { [weak self] in
                self?.animateBlur(duration: fadeDuration, blur: 0, from: 5)
                // Cleanup
                DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration, execute: {
                    oldIconShape?.removeFromParent()
                })
            })
        })
    }

    func animateBlur(duration: CGFloat, blur targetBlur: CGFloat, from: CGFloat) {
        let blurFade = SKAction.customAction(withDuration: duration, actionBlock: { [weak self] (node, elapsed) in
            let percent = elapsed / CGFloat(duration)

            let difference = (targetBlur - from)
            let currentBlur = from + (difference * percent)

            self?.filter.blurFilter?.setValue(currentBlur, forKey: kCIInputRadiusKey)
        })

        scene.run(blurFade)
    }
}

extension UIImage {

    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
