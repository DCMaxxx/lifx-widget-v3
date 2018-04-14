//
//  TutorialViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 15/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper
import SwiftyUserDefaults
import SVProgressHUD

final class TutorialViewController: UIViewController {

    var onCompletion: (([LIFXLight]) -> Void)?

    fileprivate var lights: [LIFXLight] = []

    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var pageControler: UIPageControl!
    @IBOutlet fileprivate weak var hiddenContentViewConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var hiddenValidOAuthTokenViewConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var pageViews: [UIView]!

    @IBAction private func pressedDoneButton(_ sender: UIButton) {
        dismissIfPossible()
    }

    @IBAction private func tappedMainView(_ sender: UITapGestureRecognizer) {
        dismissIfPossible()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        transitioningDelegate = self
        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let destination as TokenPickerViewController:
            configure(tokenPicker: destination)
        default:
            break
        }
    }

    private func configure(tokenPicker: TokenPickerViewController) {
        tokenPicker.onValidation = { [weak self] token in
            self?.fetchLights(with: token)
        }
    }

}

// MARK: - Dismissal
extension TutorialViewController {

    fileprivate func dismissIfPossible() {
        guard API.shared.isConfigured else {
            presentAuthenticationAlert()
            scrollTo(page: .setup)
            return
        }

        onCompletion?(lights)
        dismiss(animated: true, completion: nil)
    }

    fileprivate func presentAuthenticationAlert() {
        let alertController = UIAlertController(title: "tutorial.alert.auth_required.title".localized(),
                                                message: "tutorial.alert.auth_required.body".localized(),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "tutorial.alert.auth_required.cancel".localized(),
                                                style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}

// MARK: Validating token
extension TutorialViewController {

    fileprivate func fetchLights(with token: String?) {
        guard let token = token else {
            return
        }

        SVProgressHUD.show(withStatus: "token_picker.loader.validate_token".localized())
        API.shared.configure(token: token)
        API.shared.lights()
            .onSuccess(callback: update(lights:))
            .onFailure(callback: display(error:))
    }

    private func update(lights: [LIFXLight]) {
        SVProgressHUD.dismiss()

        self.lights = lights

        hiddenValidOAuthTokenViewConstraint.priority = .defaultLow
        scrollView.layoutIfNeeded(animationDuration: 0.5, springDamping: 0.5) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.scrollTo(page: .conclusion)
            }
        }
    }

    private func display(error: Error) {
        SVProgressHUD.dismiss()

        let alertController = UIAlertController(title: "tutorial.alert.invalid_token.title".localized(),
                                                message: "tutorial.alert.invalid_token.body".localized(withVariables: [
                                                    "desc": error.localizedDescription
                                                    ]),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "tutorial.alert.invalid_token.cancel".localized(),
                                                style: .cancel,
                                                handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}

// MARK: - UIGestureRecognizerDelegate
extension TutorialViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // The gesture recognizer dismisses the view. We don't want to dismiss if the user taps a pageView
        return pageViews.filter { touch.view?.isDescendant(of: $0) == true }.isEmpty
    }

}

// MARK: - UIScrollViewDelegate
extension TutorialViewController: UIScrollViewDelegate {

    fileprivate enum Page: Int {
        case intro
        case setup
        case conclusion
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateScrollFromPosition()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateScrollFromPosition()
        }
    }

    fileprivate func scrollTo(page: Page) {
        let offsetForRequestedPage = scrollViewPageWidth * CGFloat(page.rawValue)
        let point = CGPoint(x: offsetForRequestedPage, y: 0)
        pageControler.currentPage = page.rawValue
        scrollView.setContentOffset(point, animated: true)
    }

    private func updateScrollFromPosition() {
        pageControler.currentPage = currentPageIdx

        if currentPageIdx > Page.setup.rawValue && !API.shared.isConfigured {
            presentAuthenticationAlert()
            scrollTo(page: .setup)
        }
    }

    private var scrollViewPageWidth: CGFloat {
        return scrollView.bounds.width
    }

    private var currentPageIdx: Int {
        return Int(scrollView.contentOffset.x / scrollViewPageWidth)
    }

}

// MARK: - UIViewControllerTransitioningDelegate
extension TutorialViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard presented is TutorialViewController else {
            return nil
        }
        return TutorialAnimatedTransitioning(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard dismissed is TutorialViewController else {
            return nil
        }
        return TutorialAnimatedTransitioning(isPresenting: false)
    }

    func layoutHiddenView() {
        hiddenContentViewConstraint.priority = UILayoutPriority.defaultHigh
        view.layoutIfNeeded()
    }

    func layoutVisibleView() {
        hiddenContentViewConstraint.priority = UILayoutPriority.defaultLow
        view.layoutIfNeeded()
    }

}
