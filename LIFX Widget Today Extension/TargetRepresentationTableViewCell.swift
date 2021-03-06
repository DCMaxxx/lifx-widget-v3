//
//  TargetRepresentationTableViewCell.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 28/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

protocol TargetRepresentationTableViewCellDelegate: class {

    func userDidPowerOn(in cell: TargetRepresentationTableViewCell)
    func userDidPowerOff(in cell: TargetRepresentationTableViewCell)
    func userDidSelect(brightness: Brightness, in cell: TargetRepresentationTableViewCell)
    func userDidSelect(color: Color, in cell: TargetRepresentationTableViewCell)

}

final class TargetRepresentationTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet fileprivate weak var titleLabel: UILabel!

    @IBOutlet fileprivate weak var brightnessesCollectionView: UICollectionView!
    fileprivate var brightnessesDataSource: BrightnessesPickerDataSource!

    @IBOutlet fileprivate weak var targetContentView: UIView!
    @IBOutlet fileprivate weak var colorsCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var topSpacing: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomSpacing: NSLayoutConstraint!
    @IBOutlet fileprivate weak var colorsCollectionViewHeight: NSLayoutConstraint!
    fileprivate var colorsDataSource: ColorsPickerDataSource!

    fileprivate var isAvailable = false
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

        // For some reason, I need to layout twice here to get the
        // collection view to be displayed the first time...
        layoutIfNeeded(animationDuration: 0.5, springDamping: 0.6)
        layoutIfNeeded(animationDuration: 0.5, springDamping: 0.6) { _ in
            self.colorsCollectionView.reloadData()
        }
    }

    private func displayBrightnessesCollectionView(visible: Bool) {
        if let layout = brightnessesCollectionView.collectionViewLayout as? BrightnessesCollectionViewLayout {
            layout.isCondensed = !visible
        }
    }

    func animateForUnavailableTargetIfNeeded() -> Bool {
        if isAvailable {
            return false
        }
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.5
        animation.values = [-15.0, 15.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        targetContentView.layer.add(animation, forKey: nil)
        return true
    }

}

// MARK: - Configuration methods
extension TargetRepresentationTableViewCell {

    func configure(with status: TargetStatus,
                   delegate: TargetRepresentationTableViewCellDelegate?) {
        self.delegate = delegate
        self.isAvailable = status.isConnected

        contentView.backgroundColor = status.currentColor
        titleLabel.text = status.target.name

        brightnessesCollectionView.isHidden = !isAvailable
        brightnessesDataSource.reload(isOn: status.isOn)
        brightnessesDataSource.selectClosestBrightnessCell(with: status.currentBrightness,
                                                           in: brightnessesCollectionView)

        reloadTintColor(isBackgroundlight: status.currentColor.isLight)
    }

    fileprivate func reloadTintColor(isBackgroundlight light: Bool) {
        let foregroundColor: UIColor = (light ? #colorLiteral(red: 0.2173160017, green: 0.2381722331, blue: 0.2790536284, alpha: 1) : #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1))
        titleLabel.textColor = foregroundColor
        brightnessesCollectionView.tintColor = foregroundColor
        brightnessesCollectionView.visibleCells.forEach {
            $0.tintColor = foregroundColor
        }
    }

}

extension TargetRepresentationTableViewCell: BrightnessesPickerDelegate {

    func brightnessPickerDidSelect(brightness: Brightness) {
        if animateForUnavailableTargetIfNeeded() {
            return
        }
        delegate?.userDidSelect(brightness: brightness, in: self)
    }

    func brightnessPickerDidSelectPowerOff() {
        if animateForUnavailableTargetIfNeeded() {
            return
        }
        delegate?.userDidPowerOff(in: self)
    }

    func brightnessPickerDidSelectPowerOn() {
        if animateForUnavailableTargetIfNeeded() {
            return
        }
        delegate?.userDidPowerOn(in: self)
    }

}

extension TargetRepresentationTableViewCell: ColorsPickerDelegate {

    func colorsPickerDidSelect(color: Color) {
        contentView.backgroundColor = color.displayColor
        reloadTintColor(isBackgroundlight: color.displayColor.isLight)

        let brightnessValue: Float
        switch color.kind {
        case .color(let color):
            brightnessValue = Float(color.hsba?.brightness ?? 0)
        case .white(_, let brightness):
            brightnessValue = brightness
        }

        let brightness = Brightness(value: brightnessValue)
        brightnessesDataSource.selectClosestBrightnessCell(with: brightness, in: brightnessesCollectionView)
        brightnessesDataSource.reload(isOn: true)

        delegate?.userDidSelect(color: color, in: self)
    }

}
