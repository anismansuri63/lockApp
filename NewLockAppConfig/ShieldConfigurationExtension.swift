//
//  ShieldConfigurationExtension.swift
//  NewLockAppConfig
//
//  Created by apple on 03/05/24.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
//
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        
        return button()
        
    }
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        return button()
    }
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        return button()
    }
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        return button()
    }
    func button() -> ShieldConfiguration {
        print("testing")
        let themeColor = UIColor(rgbColorCodeRed: 20,
                                 green: 166,
                                 blue: 139,
                                 alpha: 1)
        return ShieldConfiguration(backgroundBlurStyle: .systemMaterial,
                                          backgroundColor: themeColor,
                                          icon: UIImage(named: "shield-icon"),
                                          title: ShieldConfiguration.Label(text: "App Locked",
                                                                           color: .black),
                                          subtitle: ShieldConfiguration.Label(text: "App is locked by Cybersafe",
                                                                              color: .black),
                                          primaryButtonLabel: ShieldConfiguration.Label(text: "primary Button",
                                                                                        color: .black),
                                          primaryButtonBackgroundColor: .white,
                                          
                                          secondaryButtonLabel: ShieldConfiguration.Label(text: "secondary Button",
                                                                                          color: .black)
               )
    }
}

extension UIColor {
   convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {

     let redPart: CGFloat = CGFloat(red) / 255
     let greenPart: CGFloat = CGFloat(green) / 255
     let bluePart: CGFloat = CGFloat(blue) / 255

     self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
   }
}
