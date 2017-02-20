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
        case white(kelvin: Int)
    }

    let kind: Kind
    let brightness: Float

    // MARK: - Init
    init(kind: Kind, brightness: Float) {
        self.kind = kind
        self.brightness = brightness
    }

    // MARK: - JSONable
    convenience init?(json: JSON) {
        guard
            let kind = json["kind"].string,
            let brightness = json["brightness"].float else {
                print("Couldn't initialize a color from its JSON: \(json)")
                return nil
        }
        _ = brightness
        switch kind {
        case "color":
            return nil
        case "white":
            return nil
        default:
            return nil
        }
    }

    var json: JSON {
        switch kind {
        case .color(let color):
            _ = color
            return [
                "kind": "color"
            ]
        case .white(let kelvin):
            _ = kelvin
            return [
                "kind": "white"
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
