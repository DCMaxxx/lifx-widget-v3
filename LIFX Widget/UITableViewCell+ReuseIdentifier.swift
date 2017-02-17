//
//  UITableViewCell+ReuseIdentifier.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

extension UITableViewCell {

    static var identifier: String {
        // force_unwrapping: We know that components(separatedBy:) will at least have one element
        // swiftlint:disable:next force_unwrapping
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

}
