//
//  ColorPickerWhiteController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 21/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class ColorPickerWhiteController: UIViewController {

    fileprivate var hasPositionedIndicatorView = false

    fileprivate var baseKelvin: Int!
    fileprivate var baseBrightness: Float!
    fileprivate var onSelection: ColorSelectionClosure?

    @IBOutlet fileprivate weak var colorView: UIView!
    @IBOutlet fileprivate weak var brightnessSlider: UISlider!
    @IBOutlet fileprivate weak var gradientView: WhiteGradientView!
    @IBOutlet fileprivate weak var indicatorView: WhiteGradientView!
    @IBOutlet fileprivate weak var indicatorYPosition: NSLayoutConstraint!
    @IBOutlet fileprivate weak var indicatorXPosition: NSLayoutConstraint!

    @IBAction private func tappedGradientView(_ sender: UITapGestureRecognizer) {
        let position = sender.location(in: gradientView)
        updateColor(with: position)
    }

    @IBAction private func pannedGradientView(_ sender: UIPanGestureRecognizer) {
        var position = sender.location(in: gradientView)
        position.x = position.x.rangedBetween(min: 0, max: gradientView.bounds.width)
        position.y = position.y.rangedBetween(min: 0, max: gradientView.bounds.height)
        updateColor(with: position)
    }

    @IBAction private func sliderChangedValue(_ sender: UISlider) {
        let currentPosition = gradientView.convert(indicatorView.center, from: indicatorView.superview)
        updateColor(with: currentPosition)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureColorView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !hasPositionedIndicatorView {
            configureBaseIndicatorPosition()
        }
    }

    private func configureColorView() {
        colorView.layer.borderColor = UIColor.black.cgColor
        colorView.layer.borderWidth = 1 / UIScreen.main.scale

        brightnessSlider.value = baseBrightness
    }

    private func configureBaseIndicatorPosition() {
        hasPositionedIndicatorView = true

        let position = CGPoint(x: gradientView.bounds.width / 2,
                               y: gradientView.bounds.height * baseKelvin.toKelvinRatio)
        updateColor(with: position, notifySelection: false)
    }

    private func updateColor(with position: CGPoint, notifySelection: Bool = true) {
        indicatorXPosition.constant = position.x
        indicatorYPosition.constant = position.y
        view.layoutIfNeeded(animationDuration: 0.3, springDamping: 0.8)

        let currentRatio = indicatorYPosition.constant / gradientView.bounds.height
        let kelvin = currentRatio.toKelvinValue
        let brightness = brightnessSlider.value
        let color = Color(kind: .white(kelvin: kelvin, brightness: brightness))

        indicatorView.backgroundColor = color.displayColor
        colorView.backgroundColor = color.displayColor
        brightnessSlider.tintColor = color.displayColor

        if notifySelection {
            onSelection?(color)
        }
    }

}

// MARK: - Configuration method
extension ColorPickerWhiteController {

    func configure(with kelvin: Int, brightness: Float, onSelection: ColorSelectionClosure?) {
        self.baseKelvin = kelvin
        self.baseBrightness = brightness
        self.onSelection = onSelection
    }

}

private extension Int {

    var toKelvinRatio: CGFloat {
        return CGFloat(self - Int.minLifxKelvin) / CGFloat(Int.maxLifxKelvin - Int.minLifxKelvin)
    }

}

private extension CGFloat {

    var toKelvinValue: Int {
        return Int(self * CGFloat(Int.maxLifxKelvin - Int.minLifxKelvin)) + Int.minLifxKelvin
    }

}
