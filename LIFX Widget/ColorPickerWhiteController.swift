//
//  ColorPickerWhiteController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 21/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class ColorPickerWhiteController: UIViewController {

    @IBOutlet fileprivate weak var colorView: UIView!
    @IBOutlet fileprivate weak var gradientView: UIView!
    @IBOutlet fileprivate weak var brightnessSlider: UISlider!
    @IBOutlet fileprivate weak var indicatorView: UIView!
    @IBOutlet fileprivate weak var indicatorYPosition: NSLayoutConstraint!
    @IBOutlet fileprivate weak var indicatorXPosition: NSLayoutConstraint!

    @IBAction func tappedGradientView(_ sender: UITapGestureRecognizer) {

    }

    @IBAction func pannedGradientView(_ sender: UIPanGestureRecognizer) {

    }

    @IBAction func sliderChangedValue(_ sender: UISlider) {

    }

}
