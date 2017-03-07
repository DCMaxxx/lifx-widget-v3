//
//  ColorsDataSource.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 07/03/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

protocol ColorsPickerDelegate: class {

    func colorsPickerDidSelect(color: Color)

}

final class ColorsPickerDataSource: NSObject {

    fileprivate let colors: [Color]
    fileprivate weak var delegate: ColorsPickerDelegate?

    init(colors: [Color], delegate: ColorsPickerDelegate?) {
        self.colors = colors
        self.delegate = delegate
    }

    fileprivate func getColor(at indexPath: IndexPath) -> Color {
        return colors[indexPath.row]
    }

}

extension ColorsPickerDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next line_length force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as! ColorCollectionViewCell
        let color = getColor(at: indexPath)
        cell.configure(with: color)
        return cell
    }

}

extension ColorsPickerDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItems = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        let width = collectionView.bounds.width
        let itemWidth = width / CGFloat(numberOfItems)
        return CGSize(width: itemWidth, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = getColor(at: indexPath)
        delegate?.colorsPickerDidSelect(color: color)
    }

}
