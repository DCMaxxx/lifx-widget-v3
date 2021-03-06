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

    var displayColor: UIColor {
        switch kind {
        case .color(let color):
            return color
        case .white(let kelvin, let brightness):
            let kelvinColor = UIColor(kelvin: kelvin)
            guard let hsba = kelvinColor.hsba else {
                return kelvinColor
            }
            return UIColor(hue: hsba.hue, saturation: hsba.saturation,
                           brightness: CGFloat(brightness), alpha: hsba.alpha)
        }
    }

    // MARK: - Init
    init(kind: Kind) {
        self.kind = kind
    }

    init(light: LIFXLight) {
        if light.color.saturation == 0 {
            self.kind = .white(kelvin: Int(light.color.kelvin),
                               brightness: Float(light.brightness))
        } else {
            let color = UIColor(hue: CGFloat(light.color.hue) / 360,
                                saturation: light.color.saturation,
                                brightness: light.brightness,
                                alpha: 1)
            self.kind = .color(color: color)
        }
    }

    // MARK: - JSONable
    convenience init?(json: JSON) {
        guard let kind = json["kind"].string else {
            print("Couldn't initialize a color from its JSON - no kind: \(json)")
            return nil
        }

        switch kind {
        case "color":
            guard
                let hue = json["color"]["hue"].float,
                let saturation = json["color"]["saturation"].float,
                let brightness = json["color"]["brightness"].float else {
                    print("Couldn't initialize a color from its JSON - no hue, saturation, brightness: \(json)")
                    return nil
            }
            let color = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation),
                                brightness: CGFloat(brightness), alpha: 1)
            self.init(kind: .color(color: color))

        case "white":
            guard
                let kelvin = json["kelvin"].int,
                let brightness = json["brightness"].float else {
                    print("Couldn't initialize a color from its JSON - no kelvin, brightness: \(json)")
                    return nil
            }
            self.init(kind: .white(kelvin: kelvin, brightness: brightness))

        default:
            print("Couldn't initialize a color from its JSON - invalid kind: \(json)")
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
                "kelvin": kelvin,
                "brightness": brightness
            ]
        }
    }

    // MARK: - SharedArchivable
    static var archivedClassName: String {
        return "com.maxime-dechalendar.Color"
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
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Color else {
            return false
        }
        return self.equals(other: other)
    }

    static func == (lhs: Color, rhs: Color) -> Bool {
        return lhs.equals(other: rhs)
    }

    private func equals(other: Color) -> Bool {
        switch (self.kind, other.kind) {
        case (.color(let lhsColor), .color(let rhsColor)):
            return lhsColor == rhsColor
        case (.white(let lhsKelvin), .white(let rhsKelvin)):
            return lhsKelvin == rhsKelvin
        default:
            return false
        }
    }

    // MARK: - Exchanges with LIFX API
    var updateOperation: LIFXTargetOperationUpdate? {
        switch kind {
        case .color(let color):
            guard let hsba = color.hsba else {
                return nil
            }
            let update = LIFXTargetOperationUpdate(brightness: hsba.brightness)
            update?.saturation = hsba.saturation
            update?.hue = UInt(hsba.hue * 360)
            return update

        case .white(let kelvin, let brightness):
            let update = LIFXTargetOperationUpdate(kelvin: UInt(kelvin))
            update?.brightness = CGFloat(brightness)
            return update
        }
    }

}
