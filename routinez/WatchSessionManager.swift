//
//  WatchSessionManager.swift
//  routinez
//
//  Created by Megan Boudreau on 2017-11-19.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {

  private override init() {
    super.init()
  }

  // Keep a reference for the session,
  // which will be used later for sending / receiving data
  private let session: WCSession? = WCSession.default
  var iosContextUpdateHandler: (([String: Any]) -> Void)?

  var receivedContext: [String: Any]? {
    return validSession?.receivedApplicationContext
  }

  // Activate Session
  // This needs to be called to activate the session before first use!
  func startSession() {
    session?.delegate = self
    session?.activate()
  }

  private var validSession: WCSession? {
    if let session = session,
      session.isPaired && session.isWatchAppInstalled {
      return session
    }
    return nil
  }


  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
}

extension WatchSessionManager {

  private var validReachableSession: WCSession? {
    if let session = validSession,
      session.isReachable {
      return session
    }
    return nil
  }

  // Sender
  func sendMessage(
    _ message: [String : Any],
    replyHandler: (([String : Any]) -> Void)? = nil,
    errorHandler: ((Error) -> Void)? = nil) {
    validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
  }

  func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
    #if os(iOS)
      print("recieved message on ios")
    #elseif os(watchOS)
      print("wecieved message on watch os")
    #endif
  }

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
    iosContextUpdateHandler?(applicationContext)
  }
}
