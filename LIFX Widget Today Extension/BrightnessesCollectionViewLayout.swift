//
//  BrightnessesCollectionViewLayout.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 03/03/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

/**
 A collection view layout to display portfolio on the tasker's result screen
 When condensed, the first three elements are together on the left, to simulate a stack of pictures
 When not-condensed, it is a UICollectionViewFlowLayout
 */
class BrightnessesCollectionViewLayout: UICollectionViewFlowLayout {

    var isCondensed: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.5, springDamping: 0.6, animations: {
                self.collectionView?.performBatchUpdates(nil, completion: nil)
            })
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let superAttributes = super.layoutAttributesForElements(in: rect)
        guard
            let attributes = superAttributes?.map({ $0.copy() }) as? [UICollectionViewLayoutAttributes],
            let lastAttribute = attributes.last
            else {
                return nil
        }

        guard isCondensed else {
            return attributes
        }

        let selectedIndexPath = collectionView?.indexPathsForSelectedItems?.first
        attributes.forEach {
            if let selected = selectedIndexPath, selected != $0.indexPath {
                $0.alpha = 0
            }
            $0.frame = lastAttribute.frame
        }
        return attributes
    }

}
