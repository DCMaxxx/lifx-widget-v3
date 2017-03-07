//
//  TargetRepresentationTableViewCell.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 28/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

protocol TargetRepresentationTableViewCellDelegate: class {

    func userDidTapOnToggle(in cell: TargetRepresentationTableViewCell)
    func userDidSelect(brightness: Brightness, in cell: TargetRepresentationTableViewCell)
    func userDidSelect(color: Color, in cell: TargetRepresentationTableViewCell)

}

final class TargetRepresentationTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet fileprivate weak var titleLabel: UILabel!

    @IBOutlet fileprivate weak var brightnessesCollectionView: UICollectionView!
    fileprivate var brightnessesDataSource: BrightnessesPickerDataSource!

    @IBOutlet fileprivate weak var colorsCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var topSpacing: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomSpacing: NSLayoutConstraint!
    @IBOutlet fileprivate weak var colorsCollectionViewHeight: NSLayoutConstraint!
    fileprivate var colorsDataSource: ColorsPickerDataSource!

    fileprivate weak var delegate: TargetRepresentationTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        let brightnesses = PersistanceManager.brightnesses
        brightnessesDataSource = BrightnessesPickerDataSource(brightnesses: brightnesses, delegate: self)
        brightnessesCollectionView.dataSource = brightnessesDataSource
        brightnessesCollectionView.delegate = brightnessesDataSource

        let colors = PersistanceManager.colors
        colorsDataSource = ColorsPickerDataSource(colors: colors, delegate: self)
        colorsCollectionView.dataSource = colorsDataSource
        colorsCollectionView.delegate = colorsDataSource
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(true, animated: animated)

        displayColorsCollectionView(visible: selected)
        displayBrightnessesCollectionView(visible: selected)
    }

    private func displayColorsCollectionView(visible: Bool) {
        let (top, bottom, height): (CGFloat, CGFloat, CGFloat) = (visible ? (4, 4, 36) : (20, 20, 0))
        topSpacing.constant = top
        bottomSpacing.constant = bottom
        colorsCollectionViewHeight.constant = height
        colorsCollectionView.collectionViewLayout.invalidateLayout()
        layoutIfNeeded(animationDuration: 0.5, springDamping: 0.6)
    }

    private func displayBrightnessesCollectionView(visible: Bool) {
        if let layout = brightnessesCollectionView.collectionViewLayout as? BrightnessesCollectionViewLayout {
            layout.isCondensed = !visible
        }
    }

}

// MARK: - Configuration methods
extension TargetRepresentationTableViewCell {

    func configure(with targetRepresentation: TargetRepresentation,
                   delegate: TargetRepresentationTableViewCellDelegate?) {
        self.delegate = delegate

        backgroundColor = targetRepresentation.currentColor
        titleLabel.text = targetRepresentation.target.name

        brightnessesDataSource.reload(isOn: targetRepresentation.isOn)
        brightnessesDataSource.selectClosestBrightnessCell(with: targetRepresentation.currentBrightness,
                                                           in: brightnessesCollectionView)

        let foregroundColor: UIColor = (targetRepresentation.currentColor.isLight ? #colorLiteral(red: 0.2173160017, green: 0.2381722331, blue: 0.2790536284, alpha: 1) : #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1))
        titleLabel.textColor = foregroundColor
        brightnessesCollectionView.tintColor = foregroundColor
        reloadVisibleBrightnessCells(with: foregroundColor)
    }

    fileprivate func reloadVisibleBrightnessCells(with tint: UIColor) {
        brightnessesCollectionView.visibleCells.forEach {
            $0.tintColor = tint
        }
    }

}

extension TargetRepresentationTableViewCell: BrightnessesPickerDelegate {

    func brightnessPickerDidSelect(brightness: Brightness) {
        delegate?.userDidSelect(brightness: brightness, in: self)
    }

    func brightnessPickerDidDeselect() {
        delegate?.userDidTapOnToggle(in: self)
    }

}

extension TargetRepresentationTableViewCell: ColorsPickerDelegate {

    func colorsPickerDidSelect(color: Color) {
        delegate?.userDidSelect(color: color, in: self)
    }

}
