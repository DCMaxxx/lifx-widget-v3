//
//  TargetsStatuses.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 14/03/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper

class TargetsStatuses {

    let statuses: [TargetStatus]
    let lights: [LIFXLight]

    init(targets: [Target], lights: [LIFXLight]) {
        self.lights = lights
        self.statuses = targets.map { target in
            let targetedLights = TargetsStatuses.filter(lights: lights, for: target.identifier)
            return TargetStatus(target: target, lights: targetedLights)
        }
    }

}

// MARK: - Public mutation methods
extension TargetsStatuses {

    func powerOff(target: Target) {
        let connectedLights = filterConnectedLights(for: target)
        connectedLights.forEach {
            $0.isOn = false
        }
        updateStatuses(of: connectedLights)
    }

    func powerOn(target: Target) {
        let connectedLights = filterConnectedLights(for: target)
        connectedLights.forEach {
            $0.isOn = true
        }
        updateStatuses(of: connectedLights)
    }

    func update(target: Target, withBrightness brightness: Brightness) {
        let connectedLights = filterConnectedLights(for: target)
        connectedLights.forEach {
            $0.brightness = CGFloat(brightness.value)
        }
        updateStatuses(of: connectedLights)
    }

    func update(target: Target, withColor color: Color) {
        let lifxColor = LIFXColor()
        let brightness: CGFloat
        switch color.kind {
        case .white(let kelvin, let whiteBrightness):
            lifxColor.kelvin = UInt(kelvin)
            brightness = CGFloat(whiteBrightness)
            break
        case .color(let color):
            guard let hsba = color.hsba else {
                return
            }
            lifxColor.saturation = hsba.saturation
            lifxColor.hue = UInt(hsba.hue * 360)
            brightness = hsba.brightness
        }

        let connectedLights = filterConnectedLights(for: target)
        connectedLights.forEach {
            $0.color = lifxColor
            $0.brightness = brightness
        }
        updateStatuses(of: connectedLights)
    }

}

// MARK: - Private utility methods
extension TargetsStatuses {

    fileprivate func updateStatuses(of lights: [LIFXLight]) {
        for status in statuses {
            let affectedLightsForThisStatus = filterConnectedLights(for: status.target)
            for reallyAffectedLight in lights {
                if affectedLightsForThisStatus.contains(reallyAffectedLight) {
                    let a = affectedLightsForThisStatus
                    status.update(from: a)
                }
            }
        }
    }

    fileprivate func filterConnectedLights(for target: Target) -> [LIFXLight] {
        return TargetsStatuses.filter(lights: lights, for: target.identifier)//.filter { $0.isConnected }
    }

    fileprivate static func filter(lights: [LIFXLight], for identifier: String) -> [LIFXLight] {
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
