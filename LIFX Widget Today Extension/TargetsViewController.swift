//
//  TargetsViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 28/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper

final class TargetsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    fileprivate var targets: [Target] {
        return PersistanceManager.targets
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        preferredContentSize = tableView.contentSize
    }

}

extension TargetsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next line_length force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: TargetTableViewCell.identifier, for: indexPath) as! TargetTableViewCell
        let target = getTarget(at: indexPath)
        cell.configure(with: target)
        return cell
    }

    private func getTarget(at indexPath: IndexPath) -> Target {
        return targets[indexPath.row]
    }

}
