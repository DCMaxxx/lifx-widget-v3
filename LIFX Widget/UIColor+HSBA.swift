//
//  UIColor+HSBA.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 20/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

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

        let ranged = CGFloat(max(1_000, min(kelvin, 40_000)))
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

}
