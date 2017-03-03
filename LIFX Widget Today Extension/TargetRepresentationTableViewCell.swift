//
//  TargetRepresentationTableViewCell.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 28/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

protocol TargetRepresentationTableViewCellDelegate: class {

    func userDidTapOnToggleButton(in cell: TargetRepresentationTableViewCell)

}

final class TargetRepresentationTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var isOnView: UIView!

    fileprivate weak var delegate: TargetRepresentationTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(tappedOnToggleView(sender:)))
        isOnView.addGestureRecognizer(gestureRecognizer)
    }

    func tappedOnToggleView(sender: UITapGestureRecognizer) {
        delegate?.userDidTapOnToggleButton(in: self)
    }

}

// MARK: - Configuration methods
extension TargetRepresentationTableViewCell {

    func configure(with targetRepresentation: TargetRepresentation,
                   delegate: TargetRepresentationTableViewCellDelegate?) {
        self.delegate = delegate

        backgroundColor = targetRepresentation.currentColor
        titleLabel.text = targetRepresentation.target.name

        let foregroundColor: UIColor = (targetRepresentation.currentColor.isLight ? .black : .white)
        titleLabel.textColor = foregroundColor
        isOnView.backgroundColor = foregroundColor.withAlphaComponent(targetRepresentation.isOn ? 0.2 : 0)
    }

}
