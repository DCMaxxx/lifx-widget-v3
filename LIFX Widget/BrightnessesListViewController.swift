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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let destination as BrightnessPickerViewController:
            let cell = sender as? UITableViewCell
            configure(brightnessPicker: destination, selectedCell: cell)
        default:
            break
        }
    }

    private func configure(brightnessPicker: BrightnessPickerViewController, selectedCell cell: UITableViewCell?) {
        if let cell = cell, let indexPath = tableView.indexPath(for: cell) {
            let brightness = getBrightness(at: indexPath)
            brightnessPicker.configure(with: brightness) { [weak self] newBrightness in
                self?.edit(brightness: brightness, with: newBrightness, at: indexPath)
            }
        } else {
            brightnessPicker.configure(with: nil) { [weak self] newBrightness in
                self?.add(brightness: newBrightness)
            }
        }
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

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeBrightness(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func getBrightness(at indexPath: IndexPath) -> Brightness {
        return brightnesses[indexPath.row]
    }

}

// MARK: - Adding, editing, removing brightnesses
extension BrightnessesListViewController {

    fileprivate func removeBrightness(at indexPath: IndexPath) {
        let brightness = getBrightness(at: indexPath)
        guard let idx = PersistanceManager.brightnesses.index(of: brightness) else {
            return
        }
        PersistanceManager.brightnesses.remove(at: idx)
    }

    fileprivate func edit(brightness: Brightness, with newBrightness: Brightness, at indexPath: IndexPath) {
        guard let idx = PersistanceManager.brightnesses.index(of: brightness) else {
            return
        }
        PersistanceManager.brightnesses.remove(at: idx)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        add(brightness: newBrightness)
    }

    fileprivate func add(brightness: Brightness) {
        let idx = PersistanceManager.brightnesses.sortedInsert(element: brightness)
        let newIndexPath = IndexPath(row: idx, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }

}
