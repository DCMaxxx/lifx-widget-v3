//
//  BrightnessPickerViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper

final class BrightnessPickerViewController: UIViewController {

    typealias BrightnessSelectionClosure = ((Brightness) -> Void)

    fileprivate var brightness: Brightness! // Always set in configure(with:onSelection:)
    fileprivate var onSelection: BrightnessSelectionClosure?

    fileprivate var feedbackTarget: LIFXTargetable?
    fileprivate var updateFeedbackTarget: DispatchWorkItem?
    fileprivate static let feedbackDelay: TimeInterval = 0.05

    @IBOutlet fileprivate weak var brightnessSlider: UISlider!
    @IBOutlet fileprivate weak var brightnessLabel: UILabel!
    @IBOutlet fileprivate weak var liveFeedbackTargetButton: UIBarButtonItem!

    @IBAction private func tappedDoneButton(_ sender: UIBarButtonItem) {
        onSelection?(brightness)
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction private func sliderValueChanged(_ sender: UISlider) {
        brightness = Brightness(value: sender.value)
        brightnessLabel.text = brightness.description
        notifyFeedbackTarget()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        brightnessSlider.value = brightness.value
        brightnessLabel.text = brightness.description
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let destination as TargetsPickerFeedbackViewController:
            configure(feedbackPickerController: destination)
        default:
            break
        }
    }

    private func configure(feedbackPickerController: TargetsPickerFeedbackViewController) {
        feedbackPickerController.configure { [weak self] name, target in
            self?.updateFeedbackTarget(name: name, target: target)
        }
    }

}

// MARK: - Public configuration method
extension BrightnessPickerViewController {

    func configure(with brightness: Brightness?, onSelection: BrightnessSelectionClosure?) {
        self.brightness = brightness ?? Brightness(value: 0.5)
        self.onSelection = onSelection
    }

}

// MARK: - Live feedback
extension BrightnessPickerViewController {

    fileprivate func updateFeedbackTarget(name: String, target: LIFXTargetable) {
        let buttonTitle = "color_picker.button.title.picked_feedback_light"
        liveFeedbackTargetButton.title = buttonTitle.localized(withVariables: ["name": name]).uppercased()

        feedbackTarget = target
        notifyFeedbackTarget()
    }

    fileprivate func notifyFeedbackTarget() {
        guard feedbackTarget != nil else {
            return
        }

        updateFeedbackTarget?.cancel()
        updateFeedbackTarget = DispatchWorkItem { [weak self] in
            guard let target = self?.feedbackTarget, let brightness = self?.brightness else {
                return
            }

            _ = API.shared.update(target: target, with: brightness.updateOperation)
        }
        if let task = updateFeedbackTarget {
            let delay = BrightnessPickerViewController.feedbackDelay
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
        }
    }

}
