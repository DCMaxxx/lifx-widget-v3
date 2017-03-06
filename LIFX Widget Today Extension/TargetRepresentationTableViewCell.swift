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

}

final class TargetRepresentationTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet fileprivate weak var titleLabel: UILabel!

    @IBOutlet fileprivate weak var brightnessesCollectionView: UICollectionView!
    fileprivate var lastSelectedBrightnessIndexPath: IndexPath?

    fileprivate weak var delegate: TargetRepresentationTableViewCellDelegate?
    fileprivate var brightnesses: [Brightness] {
        return PersistanceManager.brightnesses
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        brightnessesCollectionView.dataSource = self
        brightnessesCollectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(true, animated: animated)

        if let layout = brightnessesCollectionView.collectionViewLayout as? BrightnessesCollectionViewLayout {
            layout.isCondensed = !selected
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

extension TargetRepresentationTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brightnesses.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next line_length force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrightnessCollectionViewCell.identifier, for: indexPath) as! BrightnessCollectionViewCell
        let brightness = getBrightness(at: indexPath)
        cell.configure(with: brightness, tint: collectionView.tintColor)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItems = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        let width = collectionView.bounds.width
        let itemWidth = width / CGFloat(numberOfItems)
        return CGSize(width: itemWidth, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if lastSelectedBrightnessIndexPath == indexPath {
            toggleTargetAndDeselectBrightness(at: indexPath)
        } else {
            selectBrightness(at: indexPath)
        }
    }

    private func toggleTargetAndDeselectBrightness(at indexPath: IndexPath) {
        lastSelectedBrightnessIndexPath = nil
        brightnessesCollectionView.deselectItem(at: indexPath, animated: true)

        delegate?.userDidTapOnToggle(in: self)
    }

    private func selectBrightness(at indexPath: IndexPath) {
        lastSelectedBrightnessIndexPath = indexPath

        let brightness = getBrightness(at: indexPath)
        delegate?.userDidSelect(brightness: brightness, in: self)
    }

    private func getBrightness(at indexPath: IndexPath) -> Brightness {
        return brightnesses[indexPath.row]
    }

}
