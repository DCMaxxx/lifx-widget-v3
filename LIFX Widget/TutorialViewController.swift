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

    fileprivate func dismissIfPossible() {
        guard SharedDefaults[.token] != nil else {
            presentAuthenticationAlert()
            scrollToLIFXCloudSetupPage()
            return
        }

        onCompletion?(lights)
        dismiss(animated: true, completion: nil)
    }

    private func presentAuthenticationAlert() {
        let alertController = UIAlertController(title: "tutorial.alert.auth_required.title".localized(),
                                                message: "tutorial.alert.auth_required.body".localized(),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "tutorial.alert.auth_required.cancel".localized(),
                                                style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}

extension TutorialViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // The gesture recognizer dismisses the view. We don't want to dismiss if the user taps a pageView
        return pageViews.filter { touch.view?.isDescendant(of: $0) == true }.isEmpty
    }

}

extension TutorialViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControlWithCurrentPage()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updatePageControlWithCurrentPage()
        }
    }

    fileprivate func scrollToLIFXCloudSetupPage() {
        scrollToPageAtIndex(1)
    }

    private var scrollViewPageWidth: Float {
        return Float(scrollView.bounds.width)
    }

    private func updatePageControlWithCurrentPage() {
        updatePageControl(with: Float(scrollView.contentOffset.x))
    }

    private func updatePageControl(with xOffset: Float) {
        pageControler.currentPage = Int(xOffset / scrollViewPageWidth)
    }

    private func scrollToPageAtIndex(_ index: Int) {
        let offsetForRequestedPage = scrollViewPageWidth * Float(index)
        let point = CGPoint(x: CGFloat(offsetForRequestedPage), y: 0)
        updatePageControl(with: offsetForRequestedPage)
        scrollView.setContentOffset(point, animated: true)
    }

}

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
        hiddenContentViewConstraint.priority = UILayoutPriorityDefaultHigh
        view.layoutIfNeeded()
    }

    func layoutVisibleView() {
        hiddenContentViewConstraint.priority = UILayoutPriorityDefaultLow
        view.layoutIfNeeded()
    }

}
