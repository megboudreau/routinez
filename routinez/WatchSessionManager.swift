//
//  WatchSessionManager.swift
//  routinez
//
//  Created by Megan Boudreau on 2017-11-19.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {

  static let sharedManager = WatchSessionManager()

  private override init() {
    super.init()
  }

  private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil

  var iosContextUpdateHandler: (([String: Any]) -> Void)?

  var receivedContext: [String: Any]? {
    return validSession?.receivedApplicationContext
  }

  func startSession() {
    session?.delegate = self
    session?.activate()
  }

  private var validSession: WCSession? {
    guard let session = session,
      session.isPaired && session.isWatchAppInstalled else {
      return nil
    }
    return session
  }

  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
  func sessionDidBecomeInactive(_ session: WCSession) {}

  func sessionDidDeactivate(_ session: WCSession) {}
}

extension WatchSessionManager {

  private var validReachableSession: WCSession? {
    if let session = validSession,
      session.isReachable {
      return session
    }
    return nil
  }

  // MARK: Application Context

  func updateApplicationContext(with data: [String: Any], successHandler: (() -> Void)? = nil, errorHandler: (() -> Void)? = nil) {
    guard let validSession = validSession else { return }
    do {
      try validSession.updateApplicationContext(data)
      successHandler?()
    } catch {
      print("ERROR updating application context")
      errorHandler?()
    }
  }

  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    self.iosContextUpdateHandler?(applicationContext)
  }

  func sendMessage(
    _ message: [String : Any],
    replyHandler: (([String : Any]) -> Void)? = nil,
    errorHandler: ((Error) -> Void)? = nil) {
    validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
  }

  func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
    print("recieved message data")

  }

  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    self.iosContextUpdateHandler?(message)
  }

  func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
    print(message)
    self.iosContextUpdateHandler?(message)

  }
}
