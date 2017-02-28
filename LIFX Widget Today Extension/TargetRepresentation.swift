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

    init(target: Target) {
        self.target = target
        self.isOn = false
        self.currentColor = .clear
    }

    init(target: Target, in lights: [LIFXLight]) {
        let targetedLights = TargetRepresentation.filter(lights: lights, for: target.identifier)

        self.target = target
        self.isOn = targetedLights.reduce(true) { $0 && $1.isConnected && $1.isOn }
        self.currentColor = .clear // TODO: Set the real color
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
