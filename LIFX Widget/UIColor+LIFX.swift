//
//  UIColor+LIFX.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 20/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper

extension UIColor {

    typealias HSBA = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)

    var hsba: HSBA? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if !getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return nil
        }
        return (hue, saturation, brightness, alpha)
    }

    // Inspired by https://gist.github.com/jimstudt/c5069349f305dd5bb6b2
    convenience init(kelvin: Int) {
        func interpolate(_ value: CGFloat, red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
            return red + (green * value) + (blue * log(value))
        }

        let ranged = CGFloat(kelvin.rangedBetween(min: 1_000, max: 40_000))
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat

        // number_separator: There's no point reading these numbers
        // swiftlint:disable number_separator
        if ranged < 6600 {
            red = 255
            green = interpolate(ranged / 100 - 2,
                                red: -155.25485562709179, green: -0.44596950469579133, blue: 104.49216199393888)
            if ranged < 2000 {
                blue = 0
            } else {
                blue = interpolate(ranged / 100 - 10,
                                   red: -254.76935184120902, green: 0.8274096064007395, blue: 115.67994401066147)
            }
        } else {
            red = interpolate(ranged / 100 - 55,
                              red: 351.97690566805693, green: 0.114206453784165, blue: -40.25366309332127)
            green = interpolate(ranged / 100 - 50,
                                red: 325.4494125711974, green: 0.07943456536662342, blue: -28.0852963507957)
            blue = 255
        }

        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }

    static var random: UIColor {
        return UIColor(hue: CGFloat(arc4random_uniform(100)) / 100,
                       saturation: CGFloat(arc4random_uniform(100)) / 100,
                       brightness: CGFloat(arc4random_uniform(100)) / 100,
                       alpha: 1)
    }

    var isLight: Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        if !getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return false
        }
        let brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000
        return brightness >= 0.5
    }

    func blend(with color: UIColor) -> UIColor {
        if self == .clear {
            return color
        }

        guard let hsba = hsba, let otherHsba = color.hsba else {
            return self
        }

        return UIColor(hue: (hsba.hue + otherHsba.hue) / 2,
                       saturation: (hsba.saturation + otherHsba.saturation) / 2,
                       brightness: (hsba.brightness + otherHsba.brightness) / 2,
                       alpha: (hsba.alpha + otherHsba.alpha) / 2)
    }

}

extension Int {

    static var minLifxKelvin: Int {
        return 2_500
    }

    static var maxLifxKelvin: Int {
        return 9_000
    }

}
