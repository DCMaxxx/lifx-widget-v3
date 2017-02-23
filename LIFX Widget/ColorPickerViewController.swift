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

    @IBOutlet fileprivate var headerButtons: [UIBarButtonItem]!
    @IBOutlet fileprivate weak var contentScrollView: UIScrollView!
    @IBOutlet fileprivate weak var liveFeedbackTargetButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var colorPickerView: MSHSBView!

    @IBAction private func tappedDoneButton(_ sender: UIBarButtonItem) {
        onSelection?(color)
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction private func tappedHeaderButton(_ sender: UIBarButtonItem) {
        guard let idx = headerButtons.index(of: sender) else {
            return
        }
        selectPage(at: idx)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        preselectDefaultPage()
    }

}

// MARK: - Public configuration method
extension ColorPickerViewController {

    func configure(with color: Color?, onSelection: ((Color) -> Void)?) {
        self.color = color ?? Color(kind: .color(color: .random))
        self.onSelection = onSelection
    }

}

// MARK: - Header views
extension ColorPickerViewController {

    fileprivate func preselectDefaultPage() {
        switch self.color.kind {
        case .color:
            selectPage(at: 0)
        case .white:
            selectPage(at: 1)
        }
    }

    fileprivate func selectPage(at index: Int) {
        let pageWidth = contentScrollView.bounds.width
        let offset = pageWidth * CGFloat(index)
        let newOffset = CGPoint(x: offset, y: 0)
        UIView.animate(withDuration: 0.3, springDamping: 0.8, animations: {
            self.contentScrollView.contentOffset = newOffset
        })

        selectHeaderButton(at: index)
    }

    private func selectHeaderButton(at index: Int) {
        let selectedColor = #colorLiteral(red: 0.137254902, green: 0.6980392157, blue: 0.7215686275, alpha: 1)
        let deselectedColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let font = UIFont.boldSystemFont(ofSize: 14)
        headerButtons.enumerated().forEach { idx, button in
            button.setTitleTextAttributes([
                NSForegroundColorAttributeName: (idx == index) ? selectedColor : deselectedColor,
                NSFontAttributeName: font
                ], for: .normal)
        }
    }

}
