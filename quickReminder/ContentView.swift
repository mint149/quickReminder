//
//  ContentView.swift
//  quickReminder
//
//  Created by hato on 2021/03/17.
//

import SwiftUI
import EventKit

struct ContentView: View {
    @State var authorizationStatus = "unknown"
    @State var reminderList: [EKReminder]? = [EKReminder()]

    var body: some View {
        VStack{
            ReminderList(reminders: reminderList ?? [EKReminder()])
            Text("auth:\(authorizationStatus)")
                .padding()
            Button(action: {
                let eventStore = EKEventStore()
                let defaultCalender : [EKCalendar] = [eventStore.defaultCalendarForNewReminders()!]
                let predicateForReminders = eventStore.predicateForReminders(in: defaultCalender)
                eventStore.fetchReminders(matching: predicateForReminders) { (reminders) in
                    reminderList = reminders
                }
                let newReminder: EKReminder = EKReminder(eventStore: eventStore)
                newReminder.title = "new reminder"
                newReminder.calendar = eventStore.defaultCalendarForNewReminders()
                newReminder.dueDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: Date())

                do{
                    try eventStore.save(newReminder, commit: true)
                }catch let error{
                    print(error)
                }
                
            }) {
                Text("Go!")
                
            }
        }
        .onAppear(){
            switch EKEventStore.authorizationStatus(for: EKEntityType.reminder){
            case .notDetermined:
                let eventStore = EKEventStore()
                eventStore.requestAccess(to: .reminder) { (granted, error) in
                    if granted{
                        authorizationStatus = "granted"
                    }else{
                        authorizationStatus = "failed"
                        print(error ?? "unknown error")
                    }
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
