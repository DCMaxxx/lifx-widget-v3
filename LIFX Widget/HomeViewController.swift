//
//  HomeViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 15/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper
import SVProgressHUD
import BrightFutures
import Result

class HomeViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !presentTutorialViewControllerIfNeeded() {
            self.fetchLightsIfNeeded()
        }
        PersistanceManager.setDefaultColorsIfNeeded()
        PersistanceManager.setDefaultBrightnessesIfNeeded()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let destination as TutorialViewController:
            configure(tutorialController: destination)
        default:
            break
        }
    }

}

// MARK: - Tutorial
extension HomeViewController {

    fileprivate func presentTutorialViewControllerIfNeeded() -> Bool {
        guard !API.shared.isConfigured else {
            return false
        }

        performSegue(withIdentifier: "TutorialSegue", sender: nil)
        return true
    }

    fileprivate func configure(tutorialController controller: TutorialViewController) {
        controller.onCompletion = { [weak self] lights in
            self?.update(lights: lights)
        }
    }

}

// MARK: - List the user's lights
extension HomeViewController {

    fileprivate func fetchLightsIfNeeded() {
        guard PersistanceManager.availableLights.isEmpty else {
            return
        }

        SVProgressHUD.show(withStatus: "home.loader.fetching_lights".localized())
        API.shared.lights()
            .onSuccess(callback: update(lights:))
            .onFailure(callback: display(error:))
    }

    fileprivate func update(lights: [LIFXLight]) {
        SVProgressHUD.dismiss()

        PersistanceManager.availableLights = lights
        PersistanceManager.updateTargets(with: lights)
    }

    private func display(error: NSError) {
        SVProgressHUD.dismiss()

        var message: String
        switch LIFXAPIErrorCode(rawValue: UInt(error.code)) {
        case .badToken?:
            message = "home.error.invalid_token"
        default:
            message = "home.error.other"
        }
        message = message.localized(withVariables: ["code": "\(error.code)",
                                                    "desc": error.localizedDescription])

        let alertController = UIAlertController(title: "home.alert.error.title".localized(),
                                                message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "home.alert.error.new_token".localized(),
                                                style: .default, handler: { _ in
            self.resetToken()
        }))
        alertController.addAction(UIAlertAction(title: "home.alert.error.cancel".localized(),
                                                style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    private func resetToken() {
        API.shared.reset()
        _ = presentTutorialViewControllerIfNeeded()
    }

}
