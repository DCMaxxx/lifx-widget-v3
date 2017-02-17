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
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

}
