//
//  ShieldActionExtension.swift
//  NewLockAppAction
//
//  Created by apple on 03/05/24.
//
// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
import ManagedSettings
import UIKit
import WebKit

class ShieldActionExtension: ShieldActionDelegate, NSExtensionRequestHandling {
    //com.WhiteHax.DemoiOS.ContentBlocker
    var context: NSExtensionContext?
    override init() {
        MyModel.shared
    }
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        request(action: action, completionHandler: completionHandler)
    }
    override func handle(action: ShieldAction,
                         for application: ApplicationToken,
                         completionHandler: @escaping (ShieldActionResponse) -> Void) {
        MyModel.shared.store.shield.applications?.remove(application)
        
        request(action: action, completionHandler: completionHandler)
    }
    
    func beginRequest(with context: NSExtensionContext) {
        print("beginRequest with: \(context)")
        self.context = context
    }
    func request(action: ShieldAction, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        
        switch action {
            

        case .primaryButtonPressed:
            print("pw-=['r=-p98iimaryButtonPressed")
            
            if let context = self.context, let url = URL(string: "timeout://") {
                context.open(url, completionHandler: { success in
                    if success {
                        print("Successfully opened URL")
                    } else {
                        print("Failed to open URL")
                    }
                    
                })
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                completionHandler(.defer)
            }
        case .secondaryButtonPressed:
            print("secondaryButtonPressed")
            
            completionHandler(.defer)
        @unknown default:
            fatalError()
        }
    }
}
