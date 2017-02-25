//
//  BrightnessesListViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class BrightnessesListViewController: StickyHeaderTableViewController {

    fileprivate var brightnesses: [Brightness] {
        return PersistanceManager.brightnesses
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

extension BrightnessesListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brightnesses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next line_length force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: BrightnessTableViewCell.identifier, for: indexPath) as! BrightnessTableViewCell
        let brightness = getBrightness(at: indexPath)
        cell.configure(with: brightness)
        return cell
    }

    func getBrightness(at indexPath: IndexPath) -> Brightness {
        return brightnesses[indexPath.row]
    }

}
