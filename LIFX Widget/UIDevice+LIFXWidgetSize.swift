//
//  UIDevice+LIFXWidgetSize.swift
//  LIFX Widget
//
//  Created by Maxime on 14/04/2018.
//  Copyright © 2018 DCMaxxx. All rights reserved.
//

import UIKit

extension UIDevice {

    // On iOS 9, there's no API to get the maximum widget size.
    // I've calculated maximum widget size myself and stored data on
    // iCloud Drive (numbers file).
    //
    // On iOS 10, there's a new API to get the maximum widget size.
    // We use it to size the widget correctly in the widget target,
    // however, we want to display a warning in the companion app, to
    // let the user know he should probably not select 10 targets.
    // So, future-me, for iOS 10, you should only use this method on
    // the companion-app side, and only as an information to the user.
    var maxWidgetHeight: CGFloat {
        let screen = DeviceScreen(size: UIScreen.main.bounds.size)

        switch screen {
        case .iPhone5, .iPhone6, .iPhone6Plus, .iPhone6PlusLandscape:
            return screen.height - 127
        case .iPhone5Landscape, .iPhone6Landscape:
            return screen.height - 115
        case .iPad, .iPadLandscape:
            return screen.height - 39
        case .iPadProLarge, .iPadProLargeLandscape:
            return screen.height - 197
        }
    }

}

private enum DeviceScreen {
    case iPhone5
    case iPhone5Landscape
    case iPhone6
    case iPhone6Landscape
    case iPhone6Plus
    case iPhone6PlusLandscape
    case iPad
    case iPadLandscape
    case iPadProLarge
    case iPadProLargeLandscape

    // cyclomatic_complexity: It's a switch case
    // swiftlint:disable cyclomatic_complexity
    init(size: CGSize) {
        switch (size.height, size.width) {
        case (568, _): self = .iPhone5
        case (320, _): self = .iPhone5Landscape
        case (667, _): self = .iPhone6
        case (375, _): self = .iPhone6Landscape
        case (736, _): self = .iPhone6Plus
        case (414, _): self = .iPhone6PlusLandscape
        case (1_024, 768): self = .iPad
        case (768, _): self = .iPadLandscape
        case (1_366, _): self = .iPadProLarge
        case (1_024, 1_366): self = .iPadProLargeLandscape
        default: self = .iPadProLarge
        }
    }

    var height: CGFloat {
        switch self {
        case .iPhone5: return 568
        case .iPhone5Landscape: return 320
        case .iPhone6: return 667
        case .iPhone6Landscape: return 375
        case .iPhone6Plus: return 736
        case .iPhone6PlusLandscape: return 414
        case .iPad: return 1_024
        case .iPadLandscape: return 768
        case .iPadProLarge: return 1_366
        case .iPadProLargeLandscape: return 1_024
        }
    }
}
