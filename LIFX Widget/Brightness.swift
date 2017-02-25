//
//  Brightness.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import Foundation
import LIFXAPIWrapper
import SwiftyJSON

final class Brightness: NSObject, Model {

    let value: Float

    var icon: UIImage {
        switch value {
        case 0...0.33:
            return #imageLiteral(resourceName: "brightness_low")
        case 0.33...0.66:
            return #imageLiteral(resourceName: "brightness_medium")
        default:
            return #imageLiteral(resourceName: "brightness_high")
        }
    }

    // MARK: - Init
    init(value: Float) {
        self.value = value
    }

    // MARK: JSONable
    convenience init?(json: JSON) {
        guard let value = json["value"].float else {
            print("Couldn't initialize a brightness from its JSON: \(json)")
            return nil
        }
        self.init(value: value)
    }

    var json: JSON {
        return [
            "value": JSON(value)
        ]
    }

    // MARK: - NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard let data = aDecoder.decodeObject(forKey: "rawData") as? Data else {
            print("Coudln't get raw data for a Brightness")
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
        guard let other = object as? Brightness else {
            return false
        }
        return self.equals(other: other)
    }

    static func == (lhs: Brightness, rhs: Brightness) -> Bool {
        return lhs.equals(other: rhs)
    }

    private func equals(other: Brightness) -> Bool {
        return self.value == other.value
    }

}
