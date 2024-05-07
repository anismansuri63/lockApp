//
//  MyModel.swift
//  BlockerMonitorExtension
//
//  Created by Yazan Halawa on 7/27/21.
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings
import LocalAuthentication
class MyModel: ObservableObject {
    static let shared = MyModel()
    var store = ManagedSettingsStore()
    var defaults = UserDefaults(suiteName: "group.whitehax")!
    private init() {
        loadPreSavedData()

    }

    var selectionToDiscourage = FamilyActivitySelection() {
        willSet {
//            print ("got here \(newValue)")
            print ("got here")
            
            let applications = newValue.applicationTokens
            let categories = newValue.categoryTokens
//            let webCategories = newValue.webDomainTokens
//            print(webCategories)
            //store.application.blockedApplications = newValue.applications
            
            store.shield.applications = applications
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories)
            store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories)
        }
        didSet {
            save(selection: selectionToDiscourage)
            
        }
    }
    
    func permission() {
        Task {
                do {

                    if #available(iOS 16.0, *) {
                        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                        _ = AuthorizationCenter.shared.$authorizationStatus
                            .sink() {_ in
                            switch AuthorizationCenter.shared.authorizationStatus {
                            case .notDetermined:
                                print("not determined")
                            case .denied:
                                print("denied")
                            case .approved:
                                print("approved")
                            @unknown default:
                                break
                            }
                        }
                    } else {
                        // Fallback on earlier versions
                    }

                } catch {
                    print("error for screentime is \(error)")
                }
            }
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in with Face ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                if success {
                    // Face ID authentication successful, handle login
                    print("Face ID authentication successful, handle login")
                } else {
                    // Face ID authentication failed, handle error
                    print(error?.localizedDescription)
                }
            }
        } else {
            // Face ID not available, handle accordingly
        }
    }

    func initiateMonitoring() {
        let schedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: DateComponents(hour: 23, minute: 59), repeats: true, warningTime: nil)
        
        let center = DeviceActivityCenter()
        
        do {
            try center.startMonitoring(.daily, during: schedule)
        }
        catch {
            print ("Could not start monitoring \(error)")
        }
        
//        store.dateAndTime.requireAutomaticDateAndTime = true
//        store.account.lockAccounts = true
//        store.passcode.lockPasscode = true
//        store.siri.denySiri = true
//        store.appStore.denyInAppPurchases = true
//        store.appStore.maximumRating = 200
//        store.appStore.requirePasswordForPurchases = true
//        store.media.denyExplicitContent = true
//        store.gameCenter.denyMultiplayerGaming = true
//        store.media.denyMusicService = false
        
    }
    func stopMonitoring() {
        let center = DeviceActivityCenter()
        center.stopMonitoring([DeviceActivityName.daily])
        center.stopMonitoring()
        if #available(iOS 16.0, *) {
            store = ManagedSettingsStore(named: .default)
        } else {
            store = ManagedSettingsStore()
        }
        
    }
}
extension MyModel {
    func save(selection: FamilyActivitySelection) {
        if let encoded = try? JSONEncoder().encode(selection) {
            defaults.set(encoded, forKey: "defaultsRestrictionsKey")
        }
        
    }
    func loadPreSavedData() {
        if let data = defaults.data(forKey: "defaultsRestrictionsKey") {
            do {
                selectionToDiscourage = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
                print("Decoded FamilyActivitySelection successfully")
                
                print(selectionToDiscourage.applications.count)
                print(selectionToDiscourage.categories.count)
//                for app in selectionToDiscourage.applicationTokens {
//                    
//                    
//                }
//                for app in selectionToDiscourage.applications {
//                    print(app.bundleIdentifier)
//                    print(app.localizedDisplayName)
//                    print(app.token)
//                }
//                for cate in selectionToDiscourage.categories {
//                    print(cate.localizedDisplayName)
//                    print(cate.token.debugDescription.utf8)
//                }
                
            } catch {
                print("Failed to decode FamilyActivitySelection: \(error)")
            }
        } else {
            print("No data found for key: \("defaultsRestrictionsKey")")
        }
        
        let applications = selectionToDiscourage.applicationTokens
        let categories = selectionToDiscourage.categoryTokens
        store.shield.applications = applications
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories)
        store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories)
        
    }

}

extension DeviceActivityName {
    static let daily = Self("daily")
}

