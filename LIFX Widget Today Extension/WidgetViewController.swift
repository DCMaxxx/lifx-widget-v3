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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMaximumHeight()
        displayTargetsController()
    }

    @IBAction func tappedSwitchButton(_ sender: UITapGestureRecognizer) {
        displaysError = !displaysError

        if displaysError {
            displayErrorController()
        } else {
            displayTargetsController()
        }
    }

}

// MARK: - Size handling
extension WidgetViewController: NCWidgetProviding {

    fileprivate func setupMaximumHeight() {
        if #available(iOSApplicationExtension 10, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
    }

    fileprivate func setupPreferredContentSize() {
        if #available(iOSApplicationExtension 10, *) {
            setupPreferredContentSizeForRecentOS()
        } else {
            setupPreferredContentSizeForOlderOS()
        }
    }

    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        setupPreferredContentSizeForRecentOS()
    }

    @available(iOSApplicationExtension 10.0, *)
    private func setupPreferredContentSizeForRecentOS() {
        guard let context = extensionContext else {
            return
        }

        let activeMode = context.widgetActiveDisplayMode
        let maxSize = context.widgetMaximumSize(for: activeMode)

        switch activeMode {
        case .compact:
            preferredContentSize = maxSize
        case .expanded:
            let childSize = childControllerPreferredContentSize
            let size = (childSize.height < maxSize.height ? childSize : maxSize)
            preferredContentSize = size
        }
    }

    private func setupPreferredContentSizeForOlderOS() {
        let maxHeight: CGFloat

        // See: http://stackoverflow.com/questions/24815957/maximum-height-of-ios-8-today-extension
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            maxHeight = UIScreen.main.bounds.height - 126
        case .phone:
            maxHeight = UIScreen.main.bounds.height - 171
        default:
            return
        }

        let childSize = childControllerPreferredContentSize
        var size = preferredContentSize
        size.height = min(childSize.height, maxHeight)
        preferredContentSize = size
    }

}

// MARK: - Child controller handling
extension WidgetViewController {

    fileprivate func displayErrorController() {
        let errorController: ErrorViewController = .from(storyboard: extensionStoryboard)
        insertChild(controller: errorController)
    }

    fileprivate func displayTargetsController() {
        let targetsController: TargetsViewController = .from(storyboard: extensionStoryboard)
        insertChild(controller: targetsController)
    }

    fileprivate var childControllerPreferredContentSize: CGSize {
        return childViewControllers.last?.preferredContentSize ?? preferredContentSize
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
            self.setupPreferredContentSize()
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
