//
//  TargetsStatuses.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 14/03/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper

struct TargetsStatuses {

    let statuses: [TargetStatus]
    let lights: [LIFXLight]

    init(targets: [Target], lights: [LIFXLight]) {
        self.lights = lights

        self.statuses = targets.map { target in
            let targetedLights = TargetsStatuses.filter(lights: lights, for: target.identifier)
            let availableLights = targetedLights/*.filter { $0.isConnected && $0.isOn }*/

            let isOn = targetedLights.reduce(false) { $0 || ($1.isConnected && $1.isOn) }

            let colors = availableLights.map(Color.init)
            let currentColor = colors.reduce(UIColor.clear) { $0.blend(with: $1.displayColor) }

            let totalBrightness = availableLights.map { $0.brightness }.reduce(0, +)
            let averageBrightness = totalBrightness / max(1, CGFloat(targetedLights.count))
            let currentBrightness = Brightness(value: Float(averageBrightness))

            return TargetStatus(target: target, isOn: isOn,
                                currentColor: currentColor, currentBrightness: currentBrightness)
        }
    }

    func powerOff(at index: Int) -> [Int] {
        // TODO: We should power off, and return the affected statuses
        return []
    }

    private static func buildTargetRepresentation() {
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
