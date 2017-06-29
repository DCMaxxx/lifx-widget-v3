//
//  InterfaceController.swift
//  LIFX Widget WatchKit Extension
//
//  Created by Maxime de Chalendar on 15/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet private var targetsTable: WKInterfaceTable!

    private var lastDisplayedUpdate: Date! // set in awake(withContext:)

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        updateContent()
        WatchSession.shared.onContentUpdate = { [weak self] in
            self?.updateContent()
        }
    }

    override func contextForSegue(withIdentifier segueIdentifier: String,
                                  in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return PersistanceManager.targets[rowIndex]
    }

    private func updateContent() {
        if let lastDisplayedUpdate = lastDisplayedUpdate, lastDisplayedUpdate >= PersistanceManager.lastUpdate {
            return
        }
        lastDisplayedUpdate = PersistanceManager.lastUpdate

        let targets = PersistanceManager.targets
        targetsTable.setNumberOfRows(targets.count, withRowType: TargetRowController.identifier)
        targets.enumerated().forEach { idx, target in
            let row = targetsTable.rowController(at: idx) as? TargetRowController
            row?.configure(with: target)
        }
    }

}
