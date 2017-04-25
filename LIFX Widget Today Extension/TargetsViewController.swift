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

    @IBOutlet fileprivate weak var tableView: UITableView!

    fileprivate var targetsStatuses: TargetsStatuses!// = TargetsStatuses(targets: PersistanceManager.targets)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        preferredContentSize = tableView.contentSize
    }

}

extension TargetsViewController {

    func configure(with lights: [LIFXLight]) {
        targetsStatuses = TargetsStatuses(targets: PersistanceManager.targets, lights: lights)
        tableView.reloadData()
        DispatchQueue.main.async {
            self.preferredContentSize = self.tableView.contentSize
        }
    }

}

extension TargetsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetsStatuses.statuses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next line_length force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: TargetRepresentationTableViewCell.identifier, for: indexPath) as! TargetRepresentationTableViewCell
        let status = getStatus(at: indexPath)
        cell.configure(with: status, delegate: self)
        return cell
    }

    fileprivate func getStatus(at indexPath: IndexPath) -> TargetStatus {
        return targetsStatuses.statuses[indexPath.row]
    }

}

extension TargetsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath == tableView.indexPathForSelectedRow {
            deselectSelectedRow()
            return nil
        }
        return indexPath
    }

    fileprivate func deselectSelectedRow() {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension TargetsViewController: TargetRepresentationTableViewCellDelegate {

    func userDidPowerOn(in cell: TargetRepresentationTableViewCell) {
        deselectSelectedRow()
        guard let status = getStatus(for: cell) else {
            return
        }
        targetsStatuses.powerOn(target: status.target)
        tableView.reloadData()
    }

    func userDidPowerOff(in cell: TargetRepresentationTableViewCell) {
        deselectSelectedRow()
        guard let status = getStatus(for: cell) else {
            return
        }
        targetsStatuses.powerOff(target: status.target)
        tableView.reloadData()
    }

    func userDidSelect(brightness: Brightness, in cell: TargetRepresentationTableViewCell) {
        deselectSelectedRow()
        guard let status = getStatus(for: cell) else {
            return
        }
        targetsStatuses.update(target: status.target, withBrightness: brightness)
        tableView.reloadData()
    }

    func userDidSelect(color: Color, in cell: TargetRepresentationTableViewCell) {
        deselectSelectedRow()
        guard let status = getStatus(for: cell) else {
            return
        }
        targetsStatuses.update(target: status.target, withColor: color)
        tableView.reloadData()
    }

    private func getStatus(for cell: UITableViewCell) -> TargetStatus? {
        return tableView.indexPath(for: cell).map { getStatus(at: $0) }
    }

}
