//
//  TokenPickerViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class TokenPickerViewController: UIViewController {

    var onValidation: ((String?) -> Void)?

    @IBOutlet private weak var webView: UIWebView!

    @IBAction private func pressedConfirmButton(_ sender: UIBarButtonItem) {
        dismiss()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadLIFXCloudPage()
    }

    private func loadLIFXCloudPage() {
        let url = API.tokenURL
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }

}

// MARK: - Dismissal
extension TokenPickerViewController {

    fileprivate func dismiss() {
        let pasteboard = UIPasteboard.general.string
        if let token = pasteboard, API.validate(token: token) {
            dismiss(with: token)
            return
        }

        presentConfirmDismissalAlert(for: pasteboard)
    }

    private func presentConfirmDismissalAlert(for token: String?) {
        let alertController = UIAlertController(title: "token_picker.alert.invalid_token.title".localized(),
                                                message: "token_picker.alert.invalid_token.body".localized(),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "token_picker.alert.invalid_token.cancel".localized(),
                                                style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "token_picker.alert.invalid_token.confirm".localized(),
                                                style: .default, handler: { _ in
                                                    self.dismiss(with: token)
        }))
        present(alertController, animated: true, completion: nil)
    }

    private func dismiss(with token: String?) {
        dismiss(animated: true) {
            self.onValidation?(token)
        }
    }

}

// MARK: - UIBarPositioningDelegate
extension TokenPickerViewController: UIBarPositioningDelegate {

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

}
