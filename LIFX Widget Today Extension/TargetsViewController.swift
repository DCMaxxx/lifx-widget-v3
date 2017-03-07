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

    fileprivate var targetRepresentations: [TargetRepresentation] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        targetRepresentations = PersistanceManager.targets.map(TargetRepresentation.init)
        preferredContentSize = tableView.contentSize
    }

}

extension TargetsViewController {

    func configure(with lights: [LIFXLight]) {
        targetRepresentations = PersistanceManager.targets.map {
            TargetRepresentation(target: $0, in: lights)
        }
        tableView.reloadData()
        DispatchQueue.main.async {
            self.preferredContentSize = self.tableView.contentSize
        }
    }

}

extension TargetsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetRepresentations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next line_length force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: TargetRepresentationTableViewCell.identifier, for: indexPath) as! TargetRepresentationTableViewCell
        let targetRepresentation = getTargetRepresentation(at: indexPath)
        cell.configure(with: targetRepresentation, delegate: self)
        return cell
    }

    private func getTargetRepresentation(at indexPath: IndexPath) -> TargetRepresentation {
        return targetRepresentations[indexPath.row]
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

    func userDidTapOnToggle(in cell: TargetRepresentationTableViewCell) {
        deselectSelectedRow()
        // TODO: Toggle the light
    }

    func userDidSelect(brightness: Brightness, in cell: TargetRepresentationTableViewCell) {
        deselectSelectedRow()
        // TODO: Update the brightness of the light
    }

    func userDidSelect(color: Color, in cell: TargetRepresentationTableViewCell) {
        deselectSelectedRow()
        // TODO: Update the color of the light
    }

}
