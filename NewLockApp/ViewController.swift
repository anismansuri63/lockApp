//
//  ViewController.swift
//  NewLockApp
//
//  Created by apple on 24/04/24.
//

import UIKit
import FamilyControls
import SwiftUI
class ViewController: UIViewController {
    var model = MyModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let rootView = ContentView(model: self.model)
                
        let controller = UIHostingController(rootView: rootView)
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.frame
        controller.didMove(toParent: self)

    }
    @IBAction func buttonPermission() {
        
    }
    @IBAction func buttonStart() {
        let rootView = ContentView(model: self.model)
                
        let controller = UIHostingController(rootView: rootView)
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.frame
        controller.didMove(toParent: self)

//        model.initiateMonitoring()
//        let familyActivitySelection = FamilyActivitySelection(includeEntireCategory: true)
    
    }
    @IBAction func buttonStop() {

        model.initiateMonitoring()
    }
    

}

