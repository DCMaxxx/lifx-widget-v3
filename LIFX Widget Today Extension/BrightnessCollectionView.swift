//
//  BrightnessCollectionView.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 07/03/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class BrightnessCollectionView: UICollectionView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let tappedCell = visibleCells.first { $0.frame.contains(point) }
        return tappedCell != nil
    }

}
