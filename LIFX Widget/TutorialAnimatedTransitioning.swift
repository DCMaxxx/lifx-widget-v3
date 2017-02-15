//
//  TutorialAnimatedTransitioning.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 15/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class TutorialAnimatedTransitioning: NSObject {

    fileprivate let isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
}

extension TutorialAnimatedTransitioning: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentation(transitionContext)
        } else {
            animateDismissal(transitionContext)
        }
    }

    private func animatePresentation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let controller = transitionContext.viewController(forKey: .to) as? TutorialViewController else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)

        controller.view.alpha = 0
        containerView.addSubview(controller.view)
        controller.layoutHiddenView()

        UIView.animate(withDuration: duration / 3, animations: {
            controller.view.alpha = 1
        }, completion: { finished in

            // swiftlint:disable:next line_length
            UIView.animate(withDuration: duration / 3 * 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
                controller.layoutVisibleView()
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })

        })

    }

    private func animateDismissal(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let controller = transitionContext.viewController(forKey: .from) as? TutorialViewController else {
            transitionContext.completeTransition(false)
            return
        }

        let duration = transitionDuration(using: transitionContext)

        // swiftlint:disable:next line_length
        UIView.animate(withDuration: duration / 3 * 2, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            controller.layoutHiddenView()
        }, completion: { finished in

            UIView.animate(withDuration: duration / 3, animations: {
                controller.view.alpha = 0
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })

        })
    }
}
