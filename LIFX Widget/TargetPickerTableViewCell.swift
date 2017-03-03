//
//  TargetPickerTableViewCell.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper

// object_literal : It makes more sense here to use UIColor's inits
// swiftlint:disable object_literal

final class TargetPickerTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var typeLabel: UILabel!
    @IBOutlet fileprivate weak var selectedView: TargetPickerTableViewCellSelectedView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedView.animateTo(visible: selected)
    }

}

// Configuration functions
extension TargetPickerTableViewCell {

    func configure(with model: LIFXModel) {
        switch model {
        case let x as LIFXLocation: configureWithLocation(x)
        case let x as LIFXGroup:    configureWithGroup(x)
        case let x as LIFXLight:    configureWithLight(x)
        default: print("Model not handled: \(model)")
        }
    }

    private func configureWithLocation(_ location: LIFXLocation) {
        nameLabel.text = location.name
        typeLabel.text = "target_picker.cell.type.location".localized()
        backgroundColor = UIColor(white: 0.95, alpha: 1)
    }

    private func configureWithGroup(_ group: LIFXGroup) {
        nameLabel.text = group.name
        typeLabel.text = "target_picker.cell.type.group".localized()
        backgroundColor = UIColor(white: 0.98, alpha: 1)
    }

    private func configureWithLight(_ light: LIFXLight) {
        nameLabel.text = light.label
        typeLabel.text = "target_picker.cell.type.bulb".localized()
        backgroundColor = UIColor.white
    }

}
