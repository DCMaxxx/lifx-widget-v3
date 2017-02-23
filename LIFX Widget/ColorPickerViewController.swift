//
//  ColorPickerViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 21/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import MSColorPicker

final class ColorPickerViewController: UIViewController {

    fileprivate var color: Color! // Always set in configure(with: onSelection:)
    fileprivate var onSelection: ((Color) -> Void)?

    @IBOutlet fileprivate weak var colorsButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var whitesButtons: UIBarButtonItem!
    @IBOutlet fileprivate weak var contentScrollView: UIScrollView!
    @IBOutlet fileprivate weak var liveFeedbackTargetButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var colorPickerView: MSHSBView!

    @IBAction private func tappedDoneButton(_ sender: UIBarButtonItem) {
        onSelection?(color)
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction private func tappedHeaderButton(_ sender: UIBarButtonItem) {

    }

}

extension ColorPickerViewController {

    func configure(with color: Color?, onSelection: ((Color) -> Void)?) {
        self.color = color ?? Color(kind: .color(color: .random))
        self.onSelection = onSelection
    }

}
