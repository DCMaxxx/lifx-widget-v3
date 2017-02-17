//
//  StickyHeaderTableViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

class StickyHeaderTableViewController: UITableViewController {

}

/// MARK: - UIScrollViewDelegate
extension StickyHeaderTableViewController {

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if shouldUpdateHeaderPosition(for: scrollView) && decelerate == false {
            pinTableViewToHeader()
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if shouldUpdateHeaderPosition(for: scrollView) {
            pinTableViewToHeader()
        }
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                            withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if shouldUpdateHeaderPosition(for: scrollView), let header = tableView.tableHeaderView {
            let currentYPosition = tableView.contentOffset.y + tableView.contentInset.top
            let targetYPosition = targetContentOffset.pointee.y + tableView.contentInset.top
            let headerHeight = header.bounds.height
            if currentYPosition > headerHeight && targetYPosition < headerHeight {
                targetContentOffset.pointee.y = headerHeight - tableView.contentInset.top
            }
        }
    }

    fileprivate func pinTableViewToHeader() {
        guard let headerHeight = tableView.tableHeaderView?.bounds.height else {
            return
        }
        var contentOffset = tableView.contentOffset
        let scrollPosition = contentOffset.y + tableView.contentInset.top
        if scrollPosition < headerHeight / 2 {
            contentOffset.y = 0
        } else if scrollPosition < headerHeight {
            contentOffset.y = headerHeight
        } else {
            return
        }
        contentOffset.y -= tableView.contentInset.top
        tableView.setContentOffset(contentOffset, animated: true)
    }

    fileprivate func shouldUpdateHeaderPosition(for scrollView: UIScrollView) -> Bool {
        return scrollView == tableView && tableView.tableHeaderView != nil
    }

}
