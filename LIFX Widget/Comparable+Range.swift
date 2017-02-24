//
//  Comparable+Range.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 24/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import Foundation

extension Comparable {

    public func rangedBetween(min minValue: Self, max maxValue: Self) -> Self {
        return max(minValue, min(maxValue, self))
    }

}
