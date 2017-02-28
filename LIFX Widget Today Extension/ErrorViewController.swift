//
//  ErrorViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 28/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class ErrorViewController: UIViewController {

    enum Context {
        case noToken
        case invalidToken
        case other(desc: String)

        var description: String {
            switch self {
            case .noToken:          return "error.description.no_token".localized()
            case .invalidToken:     return "error.description.invalid_token".localized()
            case .other(let desc):  return desc
            }
        }
    }

    @IBOutlet fileprivate weak var titleLabel: UILabel!

    @IBAction private func tappedOpenCompanionButton(_ sender: UIButton) {
        // TODO: Open the companion app
    }

}

// MARK: - Public configuration methods
extension ErrorViewController {

    func configure(with context: Context) {
        titleLabel.text = context.description
    }

}
