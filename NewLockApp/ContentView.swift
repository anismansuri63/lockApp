//
//  ContentView.swift
//  TestScreentimeAPI
//
//  Created by Yazan Halawa on 7/27/21.
//

import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings


struct ContentView: View {
    @StateObject var model = MyModel.shared
    @State var isPresented = false
    
    var body: some View {
        Text("Loading Data...")
                    .onAppear {
                        //model.loadPreSavedData()
                    }
        Button("Permission") {
            model.permission()
            print(model.defaults.value(forKey: "primaryButtonPressed"))
            print(model.defaults.value(forKey: "secondaryButtonPressed"))
                      
        }
        Button("Select Apps to Discourage") {
            isPresented = true
        }

        .familyActivityPicker(isPresented: $isPresented, selection: $model.selectionToDiscourage)
        Button("Start Monitoring") {
            model.initiateMonitoring()
        }
        Button("Stop Monitoring") {
            model.stopMonitoring()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
