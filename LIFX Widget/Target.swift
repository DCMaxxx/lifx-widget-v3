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

final class Target: NSObject, Model {

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
    static func == (lhs: Target, rhs: Target) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}
