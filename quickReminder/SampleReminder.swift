//
//  SampleReminder.swift
//  quickReminder
//
//  Created by hato on 2021/03/17.
//

import Foundation
import EventKit

struct SampleReminder{
    static func makeSampleReminder() -> EKReminder {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: EKEntityType.reminder){
        case .notDetermined:
            eventStore.requestAccess(to: .reminder) { (granted, error) in
                print(granted)
                print(error ?? "ok")
            }
        case .restricted:
            print("unknown")
        case .denied:
            print("unknown")
        case .authorized:
            print("unknown")
        @unknown default:
            print("unknown")
        }
    
        let newReminder: EKReminder = EKReminder(eventStore: eventStore)
        newReminder.title = "new reminder"
        newReminder.calendar = eventStore.defaultCalendarForNewReminders()
        return newReminder
    }
}
