//
//  LIFX_Widget_Tests.swift
//  LIFX Widget Tests
//
//  Created by Maxime de Chalendar on 04/04/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import XCTest
import LIFXAPIWrapper
import SwiftyJSON

class TargetStatusesTests: XCTestCase {

    // MARK: - Properties
    // set in setUp()
    fileprivate var targets: [Target]!
    fileprivate var statuses: TargetsStatuses!

}

// MARK: - Tests
extension TargetStatusesTests {

    func testPowerOffShouldAffectConnectedChildren() {
//        let appart = targets[0]
//
//        let affectedIds = statuses.powerOff(target: appart)
//        let expectedAffectedIds = [
//            0, // Appart
//            1, // Salon max
//            2, // Cuisine
//            // Chambre gauche isn't affected because it's not connected
//        ]
//        XCTAssertEqual(affectedIds, expectedAffectedIds, "powerOff should return the ids of the statuses that has changed")
//
//        affectedIds
//            .map { statuses.statuses[$0] }
//            .forEach { status in
//                XCTAssertFalse(status.isOn, "powerOff should set the `isOn` property to false")
//        }
//
//        XCTAssertFalse(statuses.statuses[3].isOn, "powerOff should not have changed the `isOn` property a not-connected light")
    }

    func testPowerOffShouldAffectParents() {
//        let
    }

}

// MARK: - Setup, tear down
extension TargetStatusesTests {

    override func setUp() {
        super.setUp()

        targets = sampleTargets()
        statuses = TargetsStatuses(targets: targets, lights: sampleLights())
    }

    override func tearDown() {
        statuses = nil

        super.tearDown()
    }

    fileprivate func sampleLights() -> [LIFXLight] {
        let json = parseJSONFile(named: "SampleLights")
        let parsedLights = json.array?.flatMap { LIFXLight(dictionary: $0.dictionaryObject) }
        guard let lights = parsedLights, !lights.isEmpty else {
            fatalError("SampleLights.json doesn't contain any LIFXLight")
        }

        return lights
    }

    fileprivate func sampleTargets() -> [Target] {
        let json = parseJSONFile(named: "SampleTargets")
        let parsedTargets = json.array?.flatMap(Target.init)
        guard let targets = parsedTargets, !targets.isEmpty else {
            fatalError("SampleTargets.json doesn't contain any Target")
        }
        return targets
    }

    private func parseJSONFile(named name: String) -> JSON {
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: name, withExtension: "json") else {
            fatalError("\(name).json not found")
        }

        let data: Data
        do {
            data = try Data(contentsOf: file)
        } catch let error {
            fatalError("Couldn't read file at \(file): \(error)")
        }

        return JSON(data: data)
    }

}
