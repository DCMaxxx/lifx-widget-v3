//
//  TodayViewController.swift
//  LIFX Widget Today Extension
//
//  Created by Maxime de Chalendar on 15/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import NotificationCenter

class WidgetViewController: UIViewController {

    private var displaysError = false
    @IBOutlet fileprivate weak var containerView: UIView!

    @IBAction func tappedSwitchButton(_ sender: UITapGestureRecognizer) {
        displaysError = !displaysError

        if displaysError {
            displayErrorController()
        } else {
            displayTargetsController()
        }
    }

}

extension WidgetViewController {

    fileprivate func displayErrorController() {
        let errorController: ErrorViewController = .from(storyboard: extensionStoryboard)
        insertChild(controller: errorController)
    }

    fileprivate func displayTargetsController() {
        let targetsController: TargetsViewController = .from(storyboard: extensionStoryboard)
        insertChild(controller: targetsController)
    }

    private var extensionStoryboard: UIStoryboard {
        // force_unwrapping: We know that this controller comes from the extension's storyboard
        // swiftlint:disable:next force_unwrapping
        return storyboard!
    }

    private func resetChild() {
        guard let child = childViewControllers.last else {
            return
        }
        child.willMove(toParentViewController: nil)
        child.view.removeFromSuperview()
        child.removeFromParentViewController()
    }

    private func insertChild(controller: UIViewController) {
        UIView.transition(with: containerView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.resetChild()
            self.addChildViewController(controller)
            self.view.addSubview(controller.view)
            self.pinToEdges(view: controller.view)
            controller.didMove(toParentViewController: self)
        }, completion: nil)
    }

    private func pinToEdges(view: UIView) {
        let edgesFormat = "|[view]|"
        let opts = NSLayoutFormatOptions()
        let views: [String: UIView] = ["view": view]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:\(edgesFormat)", options: opts,
                                                          metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:\(edgesFormat)", options: opts,
                                                          metrics: nil, views: views)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(hConstraints)
        self.view.addConstraints(vConstraints)
    }

}
