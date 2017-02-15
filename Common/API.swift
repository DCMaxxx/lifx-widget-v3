//
//  API.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 15/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import LIFXAPIWrapper
import BrightFutures

// We're getting objects from Objective-C APIs,
// the doc mentions the type but the NSArray
// aren't typed.
// swiftlint:disable force_cast

// TODO: This will be fetch from the API later on
let kLIFXAPIToken = "Don't put your token on GitHub :)"

final class API {

    static let shared = API()

    fileprivate let internAPI: LIFXAPIWrapper = .shared()

    private init() {
        internAPI.setOAuthToken(kLIFXAPIToken)
    }

}

extension API {

    func lights() -> Future<[LIFXLight], NSError> {
        return Future { complete in
            internAPI.getAllLights(completion: { lights in
                complete(.success(lights as! [LIFXLight]))
            }, onFailure: { error in
                complete(.failure(error as! NSError))
            })
        }
    }

}
