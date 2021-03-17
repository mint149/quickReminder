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
    @State var title: String = ""
    @State private var selectionDate = Date()
    @State private var dateOn = true
    @State private var timeOn = true

    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("authorizationStatus:\(authorizationStatus)")
                Divider()
                HStack{
                    Toggle("setDate", isOn : $dateOn)
                    Toggle("setTime", isOn : $timeOn)
                }
                Divider()
                DatePicker("", selection: $selectionDate)
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                HStack{
                    TextField("",text: $title)
                        .border(Color(UIColor.separator))
                    Button(action: {
                        let eventStore = EKEventStore()
                        let newReminder: EKReminder = EKReminder(eventStore: eventStore)
                        
                        newReminder.title = title
                        newReminder.calendar = eventStore.defaultCalendarForNewReminders()
                        if timeOn{
                            newReminder.dueDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: selectionDate)
                        }else if dateOn{
                            let startOfDay = Calendar(identifier: .gregorian).startOfDay(for: selectionDate)
                            newReminder.dueDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: startOfDay)
                            // TODO:日付のみでなく、その日付の0時にリマインダー設定される。日付のみにする方法を調査する必要あり。
                        }
                        
                        do{
                            try eventStore.save(newReminder, commit: true)
                        }catch let error{
                            print(error)
                        }
                        
                    }) {
                        Text("登録")
                    }
                }
                Spacer()
            }
        }.padding()
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
