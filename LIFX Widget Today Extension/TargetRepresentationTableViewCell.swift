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
    @IBOutlet fileprivate weak var brightnessesCollectionView: UICollectionView!

    fileprivate weak var delegate: TargetRepresentationTableViewCellDelegate?
    fileprivate var brightnesses: [Brightness] {
        return PersistanceManager.brightnesses
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(tappedOnToggleView(sender:)))
        isOnView.addGestureRecognizer(gestureRecognizer)

        brightnessesCollectionView.dataSource = self
        brightnessesCollectionView.delegate = self
    }

    func tappedOnToggleView(sender: UITapGestureRecognizer) {
        delegate?.userDidTapOnToggleButton(in: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(true, animated: animated)

        // TODO: This is for debug purpose only
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
        isOnView.backgroundColor = foregroundColor.withAlphaComponent(targetRepresentation.isOn ? 0.2 : 0)
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

    private func getBrightness(at indexPath: IndexPath) -> Brightness {
        return brightnesses[indexPath.row]
    }

}
