//
//  TargetPickerTableViewCellSelectedView.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

// swiftlint:disable line_length

final class TargetPickerTableViewCellSelectedView: UIView {

    fileprivate var circleLayer: CAShapeLayer!
    fileprivate var tickImageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()

        setupViewIfNeeded()
    }

}

// MARK: - View setup
extension TargetPickerTableViewCellSelectedView {

    fileprivate func setupViewIfNeeded() {
        guard circleLayer == nil && tickImageView == nil else {
            return
        }
        createCircleLayer()
        createTickImageView()
    }

    private func createCircleLayer() {
        circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = tintColor.cgColor
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 1
        circleLayer.lineWidth = 1
        layer.addSublayer(circleLayer)
    }

    private func createTickImageView() {
        tickImageView = UIImageView(image: #imageLiteral(resourceName: "targets_selected_icon"))
        tickImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tickImageView)

        let edgesFormat = "|-[tickImageView]-|"
        let opts = NSLayoutFormatOptions()
        let views: [String: UIView] = ["tickImageView": tickImageView]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:\(edgesFormat)", options: opts, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:\(edgesFormat)", options: opts, metrics: nil, views: views)
        addConstraints(hConstraints)
        addConstraints(vConstraints)

        layoutIfNeeded()
    }

}

// MARK: - Public animation
extension TargetPickerTableViewCellSelectedView {

    func animateTo(visible: Bool) {
        setupViewIfNeeded()

        if visible {
            circleLayer.strokeEnd = 1
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
                self.tickImageView.transform = CGAffineTransform.identity
            }, completion: nil)
        } else {
            circleLayer.strokeEnd = 0
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.tickImageView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            }, completion: nil)
        }
    }

}
