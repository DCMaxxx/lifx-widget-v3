//
//  Array+Misc.swift
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

extension Array where Element: Comparable {

    mutating func sortedInsert(element: Element) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi) / 2
            if self[mid] < element {
                lo = mid + 1
            } else if element < self[mid] {
                hi = mid - 1
            } else {
                insert(element, at: mid)
                return mid
            }
        }

        insert(element, at: lo)
        return lo
    }

}
