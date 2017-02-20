//
//  Color.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 18/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import Foundation
import LIFXAPIWrapper
import SwiftyJSON

final class Color: NSObject, Model {

    enum Kind {
        case color(color: UIColor)
        case white(kelvin: Int, brightness: Float)
    }

    let kind: Kind

    // MARK: - Init
    init(kind: Kind) {
        self.kind = kind
    }

    // MARK: - JSONable
    convenience init?(json: JSON) {
        guard let kind = json["kind"].string else {
            print("Couldn't initialize a color from its JSON: \(json)")
            return nil
        }

        switch kind {
        case "color":
            guard
                let hue = json["color"]["hue"].float,
                let saturation = json["color"]["saturation"].float,
                let brightness = json["color"]["brightness"].float else {
                    print("Couldn't initialize a color from its JSON: \(json)")
                    return nil
            }
            let color = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation),
                                brightness: CGFloat(brightness), alpha: 1)
            self.init(kind: .color(color: color))

        case "white":
            guard
                let kelvin = json["kelvin"].int,
                let brightness = json["brightness"].float else {
                    print("Couldn't initialize a color from its JSON: \(json)")
                    return nil
            }
            self.init(kind: .white(kelvin: kelvin, brightness: brightness))
            return nil

        default:
            print("Couldn't initialize a color from its JSON: \(json)")
            return nil
        }
    }

    var json: JSON {
        switch kind {
        case .color(let color):
            guard let hsba = color.hsba else {
                print("Coudln't get the HSBA values for a color: \(color)")
                return []
            }
            return [
                "kind": "color",
                "color": [
                    "hue": Float(hsba.hue),
                    "saturation": Float(hsba.saturation),
                    "brightness": Float(hsba.brightness)
                ]
            ]
        case .white(let kelvin, let brightness):
            return [
                "kind": "white",
                "temperature": kelvin,
                "brightness": brightness
            ]
        }
    }

    // MARK: - NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard let data = aDecoder.decodeObject(forKey: "rawData") as? Data else {
            print("Coudln't get raw data for a Color")
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

    // MARK: - Equatable
    static func == (lhs: Color, rhs: Color) -> Bool {
        switch (lhs.kind, rhs.kind) {
        case (.color(let lhsColor), .color(let rhsColor)):
            return lhsColor == rhsColor
        case (.white(let lhsKelvin), .white(let rhsKelvin)):
            return lhsKelvin == rhsKelvin
        default:
            return false
        }
    }

}
