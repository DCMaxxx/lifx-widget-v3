//
//  LIFXWatchSession.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 16/06/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import Foundation
import WatchConnectivity
import BrightFutures

final class WatchSession: NSObject {

    static let shared = WatchSession()

    var onContentUpdate: (() -> Void)?

    private override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default()
            updatePersistanceManager(with: session.applicationContext)
            session.delegate = self
            session.activate()
        } else {
            print("[WatchSession] WCSession is not supported. Kinda weird since we're on the watch.")
        }
    }

}

extension WatchSession: WCSessionDelegate {

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("[WatchSession] Did receive application context : \(applicationContext)")
        updatePersistanceManager(with: applicationContext)
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        print("[WatchSession] WCSession changed state : \(activationState.rawValue)")
        requestUpdate(with: session)
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        print("[WatchSession] WCSession changed reachability : \(session.isReachable)")
        requestUpdate(with: session)
    }

    private func requestUpdate(with session: WCSession) {
        guard session.activationState == .activated && session.isReachable else {
            return
        }

        print("[WatchSession] Sending an update request, since it's activated and reachable")
        session.sendMessage([:], replyHandler: { [weak self] response in
            print("[WatchSession] Sent an update request, got response: \(response)")
            self?.updatePersistanceManager(with: response)
        }, errorHandler: { error in
            print("[WatchSession] Sent an update request, got error: \(error)")
        })
    }

    fileprivate func updatePersistanceManager(with receivedData: [String: Any]) {
        guard let content = receivedData["content"] as? [String: Any] else {
            print("Couldn't get the content from the received data")
            return
        }
        PersistanceManager.json = content
        onContentUpdate?()
    }

}
