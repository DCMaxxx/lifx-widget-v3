//
//  TargetsPickerFeedbackViewController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import LIFXAPIWrapper

final class TargetsPickerFeedbackViewController: TargetsPickerViewController {

    typealias LightSelectionClosure = ((String, LIFXTargetable) -> Void) // of LIFXLocation, LIFXGroup and LIFXLight

    fileprivate var onSelection: LightSelectionClosure?

    // MARK: - Configuration method
    func configure(onSelection: @escaping LightSelectionClosure) {
        self.onSelection = onSelection
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = getModel(at: indexPath)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.notifySelection(of: model)
            self.dismiss()
        }
    }

    // MARK: - Target selection
    private func notifySelection(of model: LIFXModel) {
        guard
            let target = model as? LIFXTargetable,
            let name = targetName(target: target) else {
                return
        }
        onSelection?(name, target)
    }

    private func targetName(target: LIFXTargetable) -> String? {
        switch target {
        case let x as LIFXLocation: return x.name
        case let x as LIFXGroup:    return x.name
        case let x as LIFXLight:    return x.label
        default: return nil
        }
    }

    private func dismiss() {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
