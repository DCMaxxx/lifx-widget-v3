//
//  BrightnessesDataSource.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 06/03/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

protocol BrightnessesPickerDelegate: class {

    func brightnessPickerDidSelect(brightness: Brightness)
    func brightnessPickerDidSelectPowerOff()
    func brightnessPickerDidSelectPowerOn()

}

final class BrightnessesPickerDataSource: NSObject {

    fileprivate let brightnesses: [Brightness]
    fileprivate var lastSelectedBrightnessIndexPath: IndexPath?
    fileprivate var currentTargetIsOn = false

    fileprivate weak var delegate: BrightnessesPickerDelegate?

    init(brightnesses: [Brightness], delegate: BrightnessesPickerDelegate?) {
        self.brightnesses = brightnesses
        self.delegate = delegate
        self.lastSelectedBrightnessIndexPath = nil
    }

    func reload(isOn: Bool) {
        currentTargetIsOn = isOn
    }

    func selectClosestBrightnessCell(with brightness: Brightness, in collectionView: UICollectionView) {
        let closestBrightness = brightnesses.enumerated().min { (lhs, rhs) -> Bool in
            return abs(lhs.element.value - brightness.value) < abs(rhs.element.value - brightness.value)
        }
        guard let closest = closestBrightness else {
            return
        }

        let indexPath = IndexPath(item: closest.offset, section: 0)
        DispatchQueue.main.async {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            collectionView.performBatchUpdates(nil, completion: nil)
            self.lastSelectedBrightnessIndexPath = indexPath
            self.reloadVisiblePowerStatus(in: collectionView)
        }
    }

    fileprivate func reloadVisiblePowerStatus(in collectionView: UICollectionView) {
        collectionView.visibleCells.flatMap {
            $0 as? BrightnessCollectionViewCell
        }.forEach {
            $0.reload(isOn: currentTargetIsOn)
        }
    }

    fileprivate func getBrightness(at indexPath: IndexPath) -> Brightness {
        return brightnesses[indexPath.row]
    }

}

extension BrightnessesPickerDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brightnesses.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next line_length force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrightnessCollectionViewCell.identifier, for: indexPath) as! BrightnessCollectionViewCell
        let brightness = getBrightness(at: indexPath)
        cell.configure(with: brightness, tint: collectionView.tintColor, isOn: currentTargetIsOn)
        return cell
    }

}

extension BrightnessesPickerDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItems = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        let width = collectionView.bounds.width
        let itemWidth = width / CGFloat(numberOfItems)
        return CGSize(width: itemWidth, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if lastSelectedBrightnessIndexPath == indexPath && !currentTargetIsOn {
            // If we have a selection, but the target is off, it means we have pre-selected based
            // and the current intensity and we just want to turn on the light
            selectBrightnessFromPreselected(at: indexPath, in: collectionView)
        }
        else if lastSelectedBrightnessIndexPath == indexPath {
            // We have a selection, the current target is on, and we're selecting the
            // same cell. Let's turn it off
            deselectBrightness(at: indexPath, in: collectionView)
        } else {
            // We're just selecting something else, we just need to apply it
            selectBrightness(at: indexPath, in: collectionView)
        }
    }

    private func selectBrightnessFromPreselected(at indexPath: IndexPath, in collectionView: UICollectionView) {
        delegate?.brightnessPickerDidSelectPowerOn()
        currentTargetIsOn = true
        reloadVisiblePowerStatus(in: collectionView)
    }

    private func deselectBrightness(at indexPath: IndexPath, in collectionView: UICollectionView) {
        lastSelectedBrightnessIndexPath = nil
        collectionView.deselectItem(at: indexPath, animated: true)

        delegate?.brightnessPickerDidSelectPowerOff()
        currentTargetIsOn = false
        reloadVisiblePowerStatus(in: collectionView)
    }

    private func selectBrightness(at indexPath: IndexPath, in collectionView: UICollectionView) {
        lastSelectedBrightnessIndexPath = indexPath

        let brightness = getBrightness(at: indexPath)
        delegate?.brightnessPickerDidSelect(brightness: brightness)
        currentTargetIsOn = true
        reloadVisiblePowerStatus(in: collectionView)
    }

}
