//
//  quickReminderApp.swift
//  quickReminder
//
//  Created by hato on 2021/03/17.
//

import SwiftUI
import EventKit

@main
struct quickReminderApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
