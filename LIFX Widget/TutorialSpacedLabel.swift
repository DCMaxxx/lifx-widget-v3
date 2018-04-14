//
//  TutorialSpacedLabel.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class TutorialSpacedLabel: UILabel {

    static let attributes: [NSAttributedStringKey: Any] = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        style.alignment = .center

        return [
            .paragraphStyle: style
        ]
    }()

    override var text: String? {
        didSet {
            attributedText = text.map {
                NSAttributedString(string: $0, attributes: TutorialSpacedLabel.attributes)
            }
        }
    }

}
