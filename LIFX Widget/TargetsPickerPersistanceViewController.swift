//
//  TargetsPickerPersistanceController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

import LIFXAPIWrapper

final class TargetsPickerPersistanceController: TargetsPickerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        preselectIndexPaths()
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
extension TargetsPickerPersistanceController {

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if PersistanceManager.targets.count == PersistanceManager.maximumTargetsCount {
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

}
