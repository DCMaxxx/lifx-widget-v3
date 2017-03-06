//
//  BrigthnessCollectionViewCell.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 03/03/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class BrightnessCollectionViewCell: UICollectionViewCell, Identifiable {

    @IBOutlet private weak var selectedView: UIView!
    @IBOutlet private weak var imageView: UIImageView!

    override var isSelected: Bool {
        didSet {
            reloadSelection()
        }
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()

        imageView.tintColor = tintColor
        reloadSelection()
    }

    func configure(with brightness: Brightness, tint: UIColor) {
        tintColor = tint
        imageView.image = brightness.icon
    }

    private func reloadSelection() {
        // force_unwrapping: This is a false positive here, we're not unwrapping anything
        // swiftlint:disable:next force_unwrapping
        let changes = ((isSelected && selectedView.backgroundColor == nil)
                        || (!isSelected && selectedView?.backgroundColor != nil))
        guard changes else {
            return
        }

        let newColor: UIColor? = (isSelected ? #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.3) : nil)
        let newScale: CGFloat = (isSelected ? 1.0 : 0.8)

        UIView.animate(withDuration: 0.3, springDamping: 0.6, animations: {
            self.selectedView.backgroundColor = newColor
            self.selectedView.transform = CGAffineTransform(scaleX: newScale, y: newScale)
        })
    }

}
