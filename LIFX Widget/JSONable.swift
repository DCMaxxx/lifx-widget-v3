//
//  JSONable.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONable {

    init?(json: JSON)

    var json: JSON { get }

}

protocol SharedArchivable: class {

    static var archivedClassName: String { get }

}

protocol Model: JSONable, SharedArchivable, NSCoding, Equatable {

}
