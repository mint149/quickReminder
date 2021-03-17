//
//  ContentView.swift
//  quickReminder
//
//  Created by hato on 2021/03/17.
//

import SwiftUI
import EventKit

struct ContentView: View {
    @State var authorizationStatus = "None"
    @State var reminderList: [EKReminder]? = [EKReminder()]

    var body: some View {
        VStack{
            ReminderList(reminders: reminderList ?? [EKReminder()])
            Text("auth:\(authorizationStatus)")
                .padding()
            Button(action: {
                let eventStore = EKEventStore()
                switch EKEventStore.authorizationStatus(for: EKEntityType.reminder){
                case .notDetermined:
                    eventStore.requestAccess(to: .reminder) { (granted, error) in
                        print(granted)
                        print(error ?? "ok")
                    }
                case .restricted:
                    authorizationStatus = "restricted"
                case .denied:
                    authorizationStatus = "denied"
                case .authorized:
                    authorizationStatus = "authorized"
                @unknown default:
                    authorizationStatus = "unknown"
                }
            
                let ekcal : [EKCalendar] = [eventStore.defaultCalendarForNewReminders()!]
                let pred = eventStore.predicateForReminders(in: ekcal)
                eventStore.fetchReminders(matching: pred) { (reminders) in
                    reminderList = reminders
                }
                let newReminder: EKReminder = EKReminder(eventStore: eventStore)
                newReminder.title = "new reminder"
                newReminder.calendar = eventStore.defaultCalendarForNewReminders()
                
                let date = Date()
                let components = Calendar.current.dateComponents(in: TimeZone.current, from: date)

                newReminder.dueDateComponents = components


                do{
                    try eventStore.save(newReminder, commit: true)
                }catch let error{
                    print(error)
                }
                
            }) {
                Text("Go!")
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
