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
            if isCondensed {
                collectionView?.performBatchUpdates(nil, completion: nil)
            } else {
                /*
                 We want elements to unstack from the left to the right.
                 If the collection view clips to bounds, then the elements aren't fully displayed during the animation.
                 To fix this, we disable clipToBounds before performing the layout update
                 and re-enable it after.
                 We have to delay the performBatchUpdate call, else it doesn't work properly
                 (the collectionView still clips its subviews).
                 */
                collectionView?.clipsToBounds = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.collectionView?.performBatchUpdates(nil) { _ in
                        self.collectionView?.clipsToBounds = true
                    }
                }
            }
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

        attributes.forEach {
            $0.frame = lastAttribute.frame
        }
        return attributes
    }

//                /*
//                 We have to adjust the transform3D because iOS sometimes goes YOLO and
//                 resets the zIndex propety when performing layout animations. (Since 2012).
//                 The drawback is that this is only a visual effect, and the cell on top might
//                 not be the one that receives the touch.
//                 However, in our case, this isn't an issue since, when condensed, the cells
//                 aren't selectable.
// Source : http://stackoverflow.com/questions/12659301/uicollectionview-setlayoutanimated-not-preserving-zindex
//                 */
//                attribute.transform3D = CATransform3DMakeTranslation(0, 0, CGFloat(numberOfElementsToStack - index))

}
