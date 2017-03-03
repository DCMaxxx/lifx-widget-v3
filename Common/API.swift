//
//  API.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 15/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import LIFXAPIWrapper
import BrightFutures
import SwiftyUserDefaults

// force_cast: We're getting objects from Objective-C APIs, the doc mentions the type but the NSArray aren't typed.
// line_length: We're dealing with Obj-C's types, with long names
// swiftlint:disable force_cast line_length

final class API {

    static let shared = API()

    fileprivate let internAPI: LIFXAPIWrapper = .shared()

    private init() {
        reconfigureIfNeeded()
    }

}

extension API {

    // force_unwrapping: We need this URL to be valid, else, the app won't work.
    // swiftlint:disable:next force_unwrapping
    static let tokenURL = URL(string: "https://cloud.lifx.com/settings")!

    static func validate(token: String) -> Bool {
        let charsCount = token.characters.count
        let invalidCharsSet = CharacterSet(charactersIn: "0123456789ABCDEFabcdef").inverted
        let invalidCharsRange = token.rangeOfCharacter(from: invalidCharsSet)

        return charsCount == 64 && invalidCharsRange == nil
    }

    var isConfigured: Bool {
        return SharedDefaults[.token] != nil
    }

    func reconfigureIfNeeded() {
        if let token = SharedDefaults[.token] {
            internAPI.setOAuthToken(token)
        }
    }

    func configure(token: String) {
        SharedDefaults[.token] = token
        internAPI.setOAuthToken(token)
    }

    func reset() {
        SharedDefaults[.token] = nil
        internAPI.setOAuthToken(nil)
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

    func update(target: LIFXTargetable, with operation: LIFXTargetOperationUpdate) -> Future<[LIFXTargetOperationResult], NSError> {
        return Future { complete in
            internAPI.apply(operation, toTarget: target, onCompletion: { results in
                complete(.success(results as! [LIFXTargetOperationResult]))
            }, onFailure: { error in
                complete(.failure(error as! NSError))
            })
        }
    }

}

// MARK: - SwiftyUserDefaults extensions

fileprivate extension DefaultsKeys {

    static let token = DefaultsKey<String?>("lifx-api-token")

}
