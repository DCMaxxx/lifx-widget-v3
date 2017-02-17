//
//  TargetsPickerViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper

final class TargetsPickerViewController: StickyHeaderTableViewController {

    fileprivate var lights: [LIFXLight] = []
    fileprivate var orderedLIFXModels: [LIFXModel] = [] // of LIFXLocation, LIFXGroup and LIFXLight

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

// MARK: - Setting up the data
extension TargetsPickerViewController {

    func configure(with lights: [LIFXLight]) {
        configureOrderedTargets(with: lights)
        preselectIndexPaths()
    }

    private func configureOrderedTargets(with lights: [LIFXLight]) {
        self.lights = lights
        lights.forEach { light in
            guard let locationIdx = orderedLIFXModels.index(of: light.location) else {
                // We don't have the location yet. Let's add location, then group, then target
                orderedLIFXModels.append(light.location)
                orderedLIFXModels.append(light.group)
                orderedLIFXModels.append(light)
                return
            }

            guard let groupIdx = orderedLIFXModels.index(of: light.group) else {
                // We have the location, but not the group. Let's add the group, then the target
                orderedLIFXModels.insert(light.group, at: locationIdx + 1)
                orderedLIFXModels.insert(light, at: locationIdx + 2)
                return
            }

            // We have both the location, and the group. We just need to add the target.
            orderedLIFXModels.insert(light, at: groupIdx + 1)
        }
    }

    private func preselectIndexPaths() {
        let targets = PersistanceManager.targets

        orderedLIFXModels.enumerated().flatMap { idx, model in
            targets.contains(where: { $0.targets(model: model) }) ? idx : nil
        }.map {
            IndexPath(row: $0, section: 0)
        }.forEach {
            tableView.selectRow(at: $0, animated: true, scrollPosition: .none)
        }
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TargetsPickerViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedLIFXModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next line_length force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: TargetPickerTableViewCell.identifier, for: indexPath) as! TargetPickerTableViewCell
        let model = getModel(at: indexPath)
        cell.configure(with: model)
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if PersistanceManager.targets.count == PersistanceManager.maximumTargetsCount - 1 {
            presentTooManyTargetsAlert()
            return nil
        }
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = getModel(at: indexPath)
        addToTargets(model: model)
    }

    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if PersistanceManager.targets.count == 1 {
            presentEmptyTargetsAlert()
            return nil
        }
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let model = getModel(at: indexPath)
        removeFromTargets(model: model)
    }

    private func addToTargets(model: LIFXModel) {
        guard let target = Target(model: model) else {
            return
        }
        PersistanceManager.targets.append(target)
    }

    private func removeFromTargets(model: LIFXModel) {
        guard let idx = PersistanceManager.targets.index(where: { $0.targets(model: model) }) else {
            return
        }
        PersistanceManager.targets.remove(at: idx)
    }

    private func presentTooManyTargetsAlert() {
        let max = PersistanceManager.maximumTargetsCount
        let body = "target_picker.alert.too_many_targets.body".localized(withVariables: ["count": "\(max)"])
        let alertController = UIAlertController(title: "target_picker.alert.too_many_targets.title".localized(),
                                                message: body,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "target_picker.alert.too_many_targets.cancel".localized(),
                                                style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    private func presentEmptyTargetsAlert() {
        let alertController = UIAlertController(title: "target_picker.alert.no_targets.title".localized(),
                                                message: "target_picker.alert.no_targets.body".localized(),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "target_picker.alert.no_targets.cancel".localized(),
                                                style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    private func getModel(at indexPath: IndexPath) -> LIFXModel {
        return orderedLIFXModels[indexPath.row]
    }

}
