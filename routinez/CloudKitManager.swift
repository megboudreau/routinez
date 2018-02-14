//
//  File.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-01-31.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {

  let container: CKContainer
  let privateDB: CKDatabase
  let zoneID: CKRecordZoneID
  let recordType: String
  let privateSubscriptionId: String
  var token: CKServerChangeToken?
  var tokenData: Data? {
    guard let token = token else { return nil }
    return NSKeyedArchiver.archivedData(withRootObject: token)
  }
  // qos is .userInitiated to pull changes, .utility for push updates
  var qos: QualityOfService = .utility

  static let sharedCKCInstance = CloudKitManager()
  class func sharedInstance() -> CloudKitManager {
    return sharedCKCInstance
  }

  // MARK: - Flags stored locally, to persist across launches
  var subscribedToPrivateChanges = false
  var createdCustomZone = false

  init() {
    // Reader TODO: change containerIdentifier to your container's name
    let containerIdentifier = "iCloud.example.routinez"
    self.container = CKContainer(identifier: containerIdentifier)
    self.privateDB = container.privateCloudDatabase
    self.zoneID = CKRecordZoneID(zoneName: "Entries", ownerName: CKCurrentUserDefaultName)
    self.recordType = "Entry"
    self.privateSubscriptionId = "new-entry-event"

//    print("CloudKitCentral zoneCreated \(self.createdCustomZone)")
  }

//  func checkForCloudKitSubsription() {
//    if ViewController.subscriptionIsLocallyCached {
//      return
//    }
//
//    let subscription = CKDatabaseSubscription(subscriptionID: "private-changes")
//
//    // You dont need to prompt user for acceptance with a silent push
//    let notificationInfo = CKNotificationInfo() // this is a silent push notification
//    notificationInfo.shouldSendContentAvailable = true
//    subscription.notificationInfo = notificationInfo
//
//    let operation = CKModifySubscriptionsOperation(
//      subscriptionsToSave: [subscription],
//      subscriptionIDsToDelete: []
//    )
//
//    operation.modifySubscriptionsCompletionBlock = { _, _, error in
//      guard error == nil else {
//        // handle error
//        return
//      }
//      ViewController.subscriptionIsLocallyCached = true
//    }
//
//    operation.qualityOfService = .utility
//    //    self.privateDB.add(operation)
//    // set up the privateDB above
//  }

  func fetchPrivateChanges(callback: () -> Void) {
    let changesOperation = CKFetchDatabaseChangesOperation(previousServerChangeToken: nil) // change to previously cached token. (nil means it will fetch everything)

    changesOperation.fetchAllChanges = true
    changesOperation.recordZoneWithIDChangedBlock = { zoneId in
      // do something here with all the zone IDs
      print(zoneId)
    }

    changesOperation.recordZoneWithIDWasDeletedBlock = { zoneID in
      print(zoneID)
      //this tells you about zones that no longer exist on the server
      // therefor clean your cached data
    }

    changesOperation.changeTokenUpdatedBlock = { changeToken in
      print(changeToken)
      // take this token and cache the new one
    }

    changesOperation.fetchDatabaseChangesCompletionBlock = { (newToken: CKServerChangeToken?, more: Bool, error: Error?) -> Void in

      guard error == nil else {
        // handle error
        return
      }

      self.token = newToken  // Cache this new token

      //        self.fetchZoneChanges(callback)
      // fetch all the zones with the zone IDs

    }

    self.privateDB.add(changesOperation)
  }

  func saveEntry(entry: Entry, viaWC: Bool) {
    let record = CKRecord(recordType: recordType, zoneID: zoneID)
    record["timestamp"] = entry.timestamp as NSDate
    record["value"] = entry.value as NSNumber
    record["name"] = entry.name as NSString
    record["isBoolValue"] = entry.isBoolValue as NSNumber

    privateDB.save(record) { _, error in
      if let error = error {
        print("saveEntry to \(self.zoneID) ERROR \(error.localizedDescription)")
      } else {
//        print("saveDate to \(self.zoneID) success")
//        if viaWC, let update = self.updateLocalData {
//          update(record)
//        }
//        #if os(iOS)
//          if !self.subscribedToPrivateChanges {
//            self.subscribeToChanges()
//          }
//        #endif
      }
    }
  }

  // Example query to get all photos from an album
//  let query = CKQuery(
//    recordType: "Photo",
//    predicate: NSPredicate(format: "AlbumReference == %@", argumentArray: [albumRecord.recordID]))

  //Parent References
//  let photoRecord = CKRecord(recordType: "Photo")
//  photoRecord.setParent(albumRecordId)


}
