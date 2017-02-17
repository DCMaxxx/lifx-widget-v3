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

    static var targets: [Target] {
        get { return SharedDefaults[.targets] }
        set { SharedDefaults[.targets] = newValue }
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

// MARK: - SwiftyUserDefaults extensions

fileprivate extension UserDefaults {

    subscript(key: DefaultsKey<[Target]>) -> [Target] {
        get { return unarchive(key) ?? [] }
        set { archive(key, newValue) }
    }

}

fileprivate extension DefaultsKeys {

    static let targets = DefaultsKey<[Target]>("targets")

}
