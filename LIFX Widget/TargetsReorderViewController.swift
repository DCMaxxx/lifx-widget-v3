//
//  TargetsReorderViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class TargetsReorderViewController: UIViewController {

    fileprivate var targets: [Target] {
        return PersistanceManager.targets
    }

    @IBOutlet fileprivate weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.setEditing(true, animated: false)
    }

}

extension TargetsReorderViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next line_length force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: TargetsReorderTableViewCell.identifier, for: indexPath) as! TargetsReorderTableViewCell
        let target = getTarget(at: indexPath)
        cell.configure(with: target)
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let target = PersistanceManager.targets.remove(at: sourceIndexPath.row)
        PersistanceManager.targets.insert(target, at: destinationIndexPath.row)
        PersistanceManager.lastUpdate = Date()
        WatchMobileSession.shared.sendUpdate()
    }

    func getTarget(at indexPath: IndexPath) -> Target {
        return targets[indexPath.row]
    }

}
