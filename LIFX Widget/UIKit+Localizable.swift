//
//  UIKit+Localizable.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

extension UILabel {

    @IBInspectable var localizedText: String {
        set (key) {
            text = key.localized()
        }
        get {
            return text ?? ""
        }
    }

}

extension UIButton {

    @IBInspectable var localizedText: String {
        set (key) {
            setTitle(key.localized(), for: .normal)
        }
        get {
            return title(for: .normal) ?? ""
        }
    }

}

extension UIBarItem {

    @IBInspectable var localizedText: String {
        set(key) {
            title = key.localized()
        }
        get {
            return title ?? ""
        }
    }

}

extension UIViewController {

    @IBInspectable var localizedTitle: String {
        set(key) {
            title = key.localized()
        }
        get {
            return title ?? ""
        }
    }

}

extension UINavigationItem {

    @IBInspectable var localizedTitle: String {
        set(key) {
            title = key.localized()
        }
        get {
            return title ?? ""
        }
    }
}
