//
//  UIView+Animations.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

extension UIView {

    class func animate(withDuration duration: TimeInterval,
                       springDamping damping: CGFloat,
                       animations: @escaping (() -> Void),
                       completion: ((Bool) -> Void)? = nil) {
        animate(withDuration: duration,
                delay: 0,
                usingSpringWithDamping: damping,
                initialSpringVelocity: 0,
                options: UIViewAnimationOptions(),
                animations: animations,
                completion: completion)
    }

    func layoutIfNeeded(animationDuration duration: TimeInterval,
                        springDamping damping: CGFloat,
                        completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, springDamping: damping, animations: {
            self.layoutIfNeeded()
        }, completion: completion)
    }

}
