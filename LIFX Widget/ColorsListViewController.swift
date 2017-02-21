//
//  ColorsPickerViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 18/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class ColorsListViewController: StickyHeaderTableViewController {

    fileprivate var colors: [Color] {
        return PersistanceManager.colors
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ColorsListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next line_length force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.identifier, for: indexPath) as! ColorTableViewCell
        let color = getColor(at: indexPath)
        cell.configure(with: color)
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeColor(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    private func removeColor(at indexPath: IndexPath) {
        let color = getColor(at: indexPath)
        guard let idx = PersistanceManager.colors.index(of: color) else {
            return
        }
        PersistanceManager.colors.remove(at: idx)
    }

    private func getColor(at indexPath: IndexPath) -> Color {
        return colors[indexPath.row]
    }

}
