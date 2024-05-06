//
//  DeviceActivityMonitorExtension.swift
//  AutoFill
//
//  Created by apple on 26/04/24.
//

import DeviceActivity
import ManagedSettings
import Foundation
import UserNotifications
import SwiftUI
import FamilyControls

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    var store = ManagedSettingsStore()
    var context: NSExtensionContext?
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        let model = MyModel.shared
        let applications = model.selectionToDiscourage.applicationTokens
        //let applications = model.loadApplicationToken()
        store = model.store
        store.shield.applications = applications.isEmpty ? nil : applications
        store.dateAndTime.requireAutomaticDateAndTime = true
        
        
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        store.shield.applications = nil
        store.dateAndTime.requireAutomaticDateAndTime = false
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        print("eventDidReachThreshold")
        
        //let store = ManagedSettingsStore()
        store.shield.applications = MyModel.shared.selectionToDiscourage.applicationTokens
        //store.shield.applicationCategories = model.selectionToDiscourage
//        store.shield.applications = shieldedApps.applicationTokens.subtracting(excludedApps.applicationTokens)
//        store.shield.applicationCategories = .specific(shieldedApps.categoryTokens, except: excludedApps.applicationTokens)
        
        let content = UNMutableNotificationContent()
        content.title = "Time's Up!"
        content.subtitle = "Answer questions to get more time."
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        let notificationName = CFNotificationName("com.example.timeout.eventDidReachThreshold" as CFString)
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        CFNotificationCenterPostNotification(notificationCenter, notificationName, nil, nil, true)
        
        if let context = context,
            let url = URL(string: "timeout://event-did-reach-threshold") {
            context.open(url, completionHandler: nil)
        }
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
    func beginRequest(with context: NSExtensionContext) {
        print("beginRequest with: \(context)")
        self.context = context
    }
}
