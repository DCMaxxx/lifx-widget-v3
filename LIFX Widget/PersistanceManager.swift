//
//  PersistanceManager.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import LIFXAPIWrapper

// TODO: Sometime, we'll need to handle the migration process

final class PersistanceManager {

    static var maximumTargetsCount: Int {
        return 5 // TODO: Calculate it based on the device and OS version.
    }

    static var availableLights: [LIFXLight] = [] // not saved across sessions

    static var targets: [Target] {
        get { return SharedDefaults[.targets] }
        set { SharedDefaults[.targets] = newValue }
    }

    static var colors: [Color] {
        get { return SharedDefaults[.colors] }
        set { SharedDefaults[.colors] = newValue }
    }

}

// MARK: - Targets
extension PersistanceManager {

    class func updateTargets(with lights: [LIFXLight]) {
        if targets.isEmpty {
            setDefaultsTargets(with: lights)
        } else {
            filterTargets(with: lights)
        }
    }

    private class func setDefaultsTargets(with lights: [LIFXLight]) {
        // Default values for lights are all lights, but no groups / locations.
        targets = lights.prefix(PersistanceManager.maximumTargetsCount).map(Target.init)
    }

    private class func filterTargets(with lights: [LIFXLight]) {
        let allIdentifiers = lights.map {
            [$0.identifier, $0.group.identifier, $0.location.identifier] as [String]
        }.flatMap { $0 }
        let uniqIdentifiers = Set(allIdentifiers)
        targets = targets.filter { uniqIdentifiers.contains($0.identifier) }
    }

}

extension PersistanceManager {

    class func setDefaultColorsIfNeeded() {
        guard colors.isEmpty else {
            return
        }

        colors = [
            Color(kind: .color(color: #colorLiteral(red: 1, green: 0.2146629095, blue: 0.138574928, alpha: 1))),
            Color(kind: .color(color: #colorLiteral(red: 0.7886506915, green: 0.2526551187, blue: 0.912491858, alpha: 1))),
            Color(kind: .color(color: #colorLiteral(red: 0.4274981618, green: 0.5163844228, blue: 0.9852721095, alpha: 1))),
            Color(kind: .color(color: #colorLiteral(red: 0.1577041149, green: 0.9904380441, blue: 0.9570897222, alpha: 1))),
            Color(kind: .white(kelvin: Int.maxLifxKelvin, brightness: 1)),
            Color(kind: .white(kelvin: Int.minLifxKelvin, brightness: 1))
        ]
    }

}

// MARK: - SwiftyUserDefaults extensions

fileprivate extension UserDefaults {

    subscript(key: DefaultsKey<[Target]>) -> [Target] {
        get { return unarchive(key) ?? [] }
        set { archive(key, newValue) }
    }

    subscript(key: DefaultsKey<[Color]>) -> [Color] {
        get { return unarchive(key) ?? [] }
        set { archive(key, newValue) }
    }

}

fileprivate extension DefaultsKeys {

    static let targets = DefaultsKey<[Target]>("com.maxime-dechalendar.targets")
    static let colors = DefaultsKey<[Color]>("com.maxime-dechalendar.colors")

}
