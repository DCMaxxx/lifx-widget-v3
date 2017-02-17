//
//  Defaults.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 15/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

// variable_name: We want to keep coherence with SwiftyUserDefautls' `Defaults` variable.
// force_unwrap: Nothing's going to work if the user defaults doesn't exist.

// swiftlint:disable variable_name
let SharedDefaults = UserDefaults(suiteName: "group.LiFXWidgetSharingDefaults")!
