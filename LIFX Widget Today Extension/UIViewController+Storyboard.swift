//
//  UIViewController+Storyboard.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 28/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

extension UIViewController: Identifiable {

    class func from<T: UIViewController>(storyboard: UIStoryboard) -> T {
        // force_cast : We want to ensure that we're getting the right controller
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }

}
