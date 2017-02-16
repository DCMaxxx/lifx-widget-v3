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

// We're getting objects from Objective-C APIs,
// the doc mentions the type but the NSArray
// aren't typed.
// swiftlint:disable force_cast

final class API {

    static let shared = API()

    fileprivate let internAPI: LIFXAPIWrapper = .shared()

    private init() {
        if let token = SharedDefaults[.token] {
            configure(token: token)
        }
    }

}

extension API {

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

}

// MARK: - SwiftyUserDefaults extensions

fileprivate extension DefaultsKeys {

    static let token = DefaultsKey<String?>("lifx-api-token")

}
