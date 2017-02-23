//
//  ColorPickerColorController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 21/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import MSColorPicker

final class ColorPickerColorController: UIViewController {

    fileprivate var color: UIColor!
    fileprivate var onSelection: ColorSelectionClosure?

    fileprivate var colorPickerview: MSHSBView {
        // force_cast: We know from IB it's a MSHSBView
        // swiftlint:disable:next force_cast
        return view as! MSHSBView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureColorView()
    }

}

// MARK: - Configuration methods
extension ColorPickerColorController {

    func configure(with color: UIColor, onSelection: ColorSelectionClosure?) {
        self.color = color
        self.onSelection = onSelection
    }

    fileprivate func configureColorView() {
        colorPickerview.delegate = self
        colorPickerview.color = color
    }

}

// MARK: - MSColorViewDelegate
extension ColorPickerColorController: MSColorViewDelegate {

    func colorView(_ colorView: MSColorView!, didChange color: UIColor!) {
        if let onSelection = onSelection {
            let lifxColor = Color(kind: .color(color: color))
            onSelection(lifxColor)
        }
    }

}
