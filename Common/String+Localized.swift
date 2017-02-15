//
//  String+Localized.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 15/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import Foundation

extension String {

    func localized(withVariables variables: [String: String] = [:]) -> String {
        var str = NSLocalizedString(self, comment: "")
        variables.forEach { key, val in
            str = str.replacingOccurrences(of: "{\(key)}", with: val)
        }
        return str
    }

}
