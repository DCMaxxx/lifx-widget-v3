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

enum WidgetSizeCalculator {
    static let cellSize: CGFloat = 110 // Configured in storyboard

    static var warningsTargetsCount: Int? {
        if #available(iOS 10, *) {
            return 5
        } else {
            return nil
        }
    }

    static var maximumTargetsCount: Int? {
        if #available(iOS 10, *) {
            return nil
        } else {
            let cellsCount = UIDevice.current.maxWidgetHeight / WidgetSizeCalculator.cellSize
            return Int(cellsCount.rounded(.down))
        }
    }

}

final class PersistanceManager {

    static var availableLights: [LIFXLight] = [] // not saved across sessions

    static var targets: [Target] {
        get { return SharedDefaults[.targets] }
        set { SharedDefaults[.targets] = newValue }
    }

    static var colors: [Color] {
        get { return SharedDefaults[.colors] }
        set { SharedDefaults[.colors] = newValue }
    }

    static var brightnesses: [Brightness] {
        get { return SharedDefaults[.brightnesses] }
        set { SharedDefaults[.brightnesses] = newValue }
    }

}

// MARK: - Migration
extension PersistanceManager {

    private static let currentVersion = "4.0"

    static func migrateIfNeeded() {
        guard SharedDefaults[.version] != currentVersion else {
            return
        }

        // Backup old values
        // Should be done for targets, colors & brightnesses too
        let oldToken = SharedDefaults[.v2APIToken]

        // Clear user defaults, because yolo
        SharedDefaults.removeAll()

        // Set new version, to it's not run again
        SharedDefaults[.version] = currentVersion

        // Re-set old values
        if let token = oldToken {
            API.shared.configure(token: token)
        }
    }

}

// MARK: - Global configuration
extension PersistanceManager {

    static func performInitialConfiguration() {
        let archivedClasses: [SharedArchivable.Type] = [
            Target.self,
            Color.self,
            Brightness.self
        ]
        archivedClasses.forEach {
            NSKeyedUnarchiver.setClass($0, forClassName: $0.archivedClassName)
            NSKeyedArchiver.setClassName($0.archivedClassName, for: $0)
        }

        migrateIfNeeded()
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
        targets = lights.prefix(WidgetSizeCalculator.maximumTargetsCount ?? .max).map(Target.init)
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
            Color(kind: .white(kelvin: .maxLifxKelvin, brightness: 1)),
            Color(kind: .white(kelvin: .minLifxKelvin, brightness: 1))
        ]
    }

}

extension PersistanceManager {

    class func setDefaultBrightnessesIfNeeded() {
        guard brightnesses.isEmpty && !SharedDefaults[.hasSetBrightnesses] else {
            return
        }
        // We don't want to force the user to have brightnesses, just set them once
        SharedDefaults[.hasSetBrightnesses] = true

        brightnesses = [
            Brightness(value: 0.1),
            Brightness(value: 0.5),
            Brightness(value: 1)
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

    subscript(key: DefaultsKey<[Brightness]>) -> [Brightness] {
        get { return unarchive(key) ?? [] }
        set { archive(key, newValue) }
    }

}

fileprivate extension DefaultsKeys {

    static let targets = DefaultsKey<[Target]>("com.maxime-dechalendar.targets")
    static let colors = DefaultsKey<[Color]>("com.maxime-dechalendar.colors")
    static let brightnesses = DefaultsKey<[Brightness]>("com.maxime-dechalendar.brightnesses")
    static let hasSetBrightnesses = DefaultsKey<Bool>("com.maxime-dechalendar.hasSetBrightnesses")

}

fileprivate extension DefaultsKeys {

    static let version = DefaultsKey<String>("com.maxime-dechalendar.version")

    static let v2APIToken = DefaultsKey<String?>("OAuthToken")
}
