//
//  TargetsPickerViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper

class TargetsPickerViewController: StickyHeaderTableViewController {

    var orderedLIFXModels: [LIFXModel] = [] // of LIFXLocation, LIFXGroup and LIFXLight

    override func viewDidLoad() {
        super.viewDidLoad()

        configureOrderedTargets(with: PersistanceManager.availableLights)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

// MARK: - Setting up the data
extension TargetsPickerViewController {

    fileprivate func configureOrderedTargets(with lights: [LIFXLight]) {
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

    func getModel(at indexPath: IndexPath) -> LIFXModel {
        return orderedLIFXModels[indexPath.row]
    }

}
