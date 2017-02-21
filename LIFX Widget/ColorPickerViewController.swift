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

    @IBOutlet fileprivate weak var colorsButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var whitesButtons: UIBarButtonItem!
    @IBOutlet fileprivate weak var contentScrollView: UIScrollView!
    @IBOutlet fileprivate weak var liveFeedbackTargetButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var colorPickerView: MSHSBView!

    @IBAction private func tappedDoneButton(_ sender: UIBarButtonItem) {

    }

    @IBAction private func tappedHeaderButton(_ sender: UIBarButtonItem) {

    }

}
