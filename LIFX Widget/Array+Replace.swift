//
//  Array+Replace.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 23/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    mutating func replace(element toReplace: Element, with newElement: Element) {
        guard let idx = index(of: toReplace) else {
            return
        }
        self[idx] = newElement
    }

}
