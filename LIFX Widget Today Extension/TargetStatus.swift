//
//  TargetStatus.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 28/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper

class TargetStatus {

    let target: Target
    private(set) var isConnected: Bool
    private(set) var isOn: Bool
    private(set) var currentColor: UIColor
    private(set) var currentBrightness: Brightness

    init(target: Target, lights: [LIFXLight]) {
        self.target = target

        // We must init all stored properties before calling our instance setup method
        // These AREN't the real init values.
        self.isConnected = false
        self.isOn = false
        self.currentColor = .white
        self.currentBrightness = Brightness(value: 0)
        update(from: lights)
    }

    func update(from lights: [LIFXLight]) {
        isConnected = (lights.first(where: { $0.isConnected }) != nil)
        isOn = (lights.first(where: { $0.isConnected && $0.isOn }) != nil)

        let colors = lights.map(Color.init)
        currentColor = colors.reduce(UIColor.clear) { $0.blend(with: $1.displayColor) }

        let totalBrightness = lights.map { $0.brightness }.reduce(0, +)
        let averageBrightness = totalBrightness / max(1, CGFloat(lights.count))
        currentBrightness = Brightness(value: Float(averageBrightness))
    }

}
