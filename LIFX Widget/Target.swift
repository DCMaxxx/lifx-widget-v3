//
//  Target.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import Foundation
import LIFXAPIWrapper
import SwiftyJSON

final class Target: NSObject, Model, LIFXTargetable {

    let identifier: String
    let name: String
    let selector: String

    // MARK: - Init
    init(identifier: String, name: String, selector: String) {
        self.identifier = identifier
        self.name = name
        self.selector = selector
    }

    // MARK: - LIFX's inits
    convenience init?(model: LIFXModel) {
        switch model {
        case let light as LIFXLight:        self.init(light: light)
        case let group as LIFXBaseGroup:    self.init(group: group)
        default:
            print("Couldn't create a target from a LIFX model: \(model)")
            return nil
        }
    }

    convenience init(light: LIFXLight) {
        self.init(identifier: light.identifier, name: light.label, selector: light.targetSelector())
    }

    convenience init(group: LIFXBaseGroup) {
        self.init(identifier: group.identifier, name: group.name, selector: group.targetSelector())
    }

    // MARK: JSONable
    convenience init?(json: JSON) {
        guard
            let identifier = json["identifier"].string,
            let name = json["name"].string,
            let selector = json["selector"].string else {
                print("Couldn't initialize a target from its JSON: \(json)")
                return nil
        }
        self.init(identifier: identifier, name: name, selector: selector)
    }

    var json: JSON {
        return [
            "identifier": JSON(identifier),
            "name": JSON(name),
            "selector": JSON(selector)
        ]
    }

    // MARK: - SharedArchivable
    static var archivedClassName: String {
        return "com.maxime-dechalendar.Target"
    }

    // MARK: - NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard let data = aDecoder.decodeObject(forKey: "rawData") as? Data else {
            print("Coudln't get raw data for a Target")
            return nil
        }

        self.init(json: JSON(data))
    }

    public func encode(with aCoder: NSCoder) {
        do {
            let data = try json.rawData()
            aCoder.encode(data, forKey: "rawData")
        } catch let error {
            print("Couldn't get data for JSON : \(json)")
            print("Error: \(error)")
        }
    }

    // MARK: Equatable
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Target else {
            return false
        }
        return self.equals(other: other)
    }

    static func == (lhs: Target, rhs: Target) -> Bool {
        return lhs.equals(other: rhs)
    }

    private func equals(other: Target) -> Bool {
        return self.identifier == other.identifier
    }

    func targets(model: LIFXModel) -> Bool {
        switch model {
        case let light as LIFXLight:        return light.identifier == identifier
        case let group as LIFXBaseGroup:    return group.identifier == identifier
        default:                            return false
        }
    }

    // MARK: LIFXTargetable
    func targetSelector() -> String! {
        return selector
    }

}
