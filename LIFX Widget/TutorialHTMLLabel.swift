//
//  TutorialHTMLLabel.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class TutorialHTMLLabel: UILabel {

    static let css = "<style type=\"text/css\">body{font-family: '-apple-system'; font-size:14;}</style>"

    override var text: String? {
        didSet {
            attributedText = text.flatMap {
                 "\(TutorialHTMLLabel.css) \($0)".data(using: .utf8, allowLossyConversion: true)
            }.flatMap {
                try? NSMutableAttributedString(data: $0,
                                               options: [.documentType: NSAttributedString.DocumentType.html],
                                               documentAttributes: nil)
            }
        }
    }

}
