//
//  LIFXWatchMobileSession.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/06/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import Foundation
import WatchConnectivity

final class WatchMobileSession: NSObject {

    static let shared = WatchMobileSession()

    private var session: WCSession?

    private override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            self.session = session
            session.activate()
        } else {
            print("[WatchSession] WCSession is not supported")
            session = nil
        }
    }

}

extension WatchMobileSession: WCSessionDelegate {

    @available(iOS 9.3, *)
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        print("[WatchMobileSession] WCSession changed state : \(activationState)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("[WatchMobileSession] WCSession did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("[WatchMobileSession] WCSession did deactivate")
    }

    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any],
                 replyHandler: @escaping ([String : Any]) -> Void) {
        replyHandler(["update": "received"])
    }

}
