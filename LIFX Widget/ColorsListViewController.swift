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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let destination as ColorPickerViewController:
            let cell = sender as? UITableViewCell
            configure(colorPicker: destination, selectedCell: cell)
        default:
            break
        }
    }

    private func configure(colorPicker: ColorPickerViewController, selectedCell cell: UITableViewCell?) {
        if let cell = cell, let indexPath = tableView.indexPath(for: cell) {
            let color = getColor(at: indexPath)
            colorPicker.configure(with: color) { [weak self] newColor in
                self?.edit(color: color, with: newColor, at: indexPath)
            }
        } else {
            colorPicker.configure(with: nil) { [weak self] newColor in
                self?.add(color: newColor)
            }
        }
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
            if PersistanceManager.colors.count == 1 {
                presentEmptyColorsAlert()
            } else {
                removeColor(at: indexPath)
            }
        }
    }

    fileprivate func getColor(at indexPath: IndexPath) -> Color {
        return colors[indexPath.row]
    }

}

// MARK: - Adding, editing, removing colors
extension ColorsListViewController {

    fileprivate func removeColor(at indexPath: IndexPath) {
        let color = getColor(at: indexPath)
        guard let idx = PersistanceManager.colors.index(of: color) else {
            return
        }
        PersistanceManager.colors.remove(at: idx)
        PersistanceManager.lastUpdate = Date()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    fileprivate func edit(color: Color, with newColor: Color, at indexPath: IndexPath) {
        PersistanceManager.colors.replace(element: color, with: newColor)
        PersistanceManager.lastUpdate = Date()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }

    fileprivate func add(color: Color) {
        PersistanceManager.colors.append(color)
        PersistanceManager.lastUpdate = Date()

        let lastIndexPath = IndexPath(row: PersistanceManager.colors.count - 1, section: 0)
        tableView.insertRows(at: [lastIndexPath], with: .automatic)
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }

    fileprivate func presentEmptyColorsAlert() {
        let alertController = UIAlertController(title: "color_picker.alert.no_targets.title".localized(),
                                                message: "color_picker.alert.no_targets.body".localized(),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "color_picker.alert.no_targets.cancel".localized(),
                                                style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}
