//
//  TargetRepresentation.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 28/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper

struct TargetRepresentation {

    let target: Target
    var isOn: Bool
    var currentColor: UIColor
    var currentBrightnessImage: UIImage

    init(target: Target) {
        self.target = target
        self.isOn = false
        self.currentColor = .clear
        self.currentBrightnessImage = #imageLiteral(resourceName: "brightness_medium")
    }

    init(target: Target, in lights: [LIFXLight]) {
        let targetedLights = TargetRepresentation.filter(lights: lights, for: target.identifier)
        let availableLights = targetedLights.filter { $0.isConnected && $0.isOn }

        self.target = target
        self.isOn = targetedLights.reduce(false) { $0 || ($1.isConnected && $1.isOn) }

        let colors = availableLights.map(Color.init)
        self.currentColor = colors.reduce(UIColor.clear) { $0.blend(with: $1.displayColor) }

        let totalBrightness = availableLights.map { $0.brightness }.reduce(0, +)
        let averageBrightness = totalBrightness / max(1, CGFloat(targetedLights.count))
        self.currentBrightnessImage = Brightness(value: Float(averageBrightness)).icon
    }

    private static func filter(lights: [LIFXLight], for identifier: String) -> [LIFXLight] {
        for light in lights where light.identifier == identifier {
            return [light]
        }
        for light in lights where light.group.identifier == identifier {
            return lights.filter { $0.group.identifier == light.group.identifier }
        }
        for light in lights where light.location.identifier == identifier {
            return lights.filter { $0.location.identifier == light.location.identifier }
        }
        return []
    }

}
