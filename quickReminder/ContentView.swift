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

    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                DatePicker("", selection: $selectionDate)
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .scaleEffect(0.8)
                    .frame(width: 280, height: 270)
            }

            VStack(alignment: .leading){
                HStack{
                    TextField("set reminder title",text: $title)
                        .border(Color(UIColor.separator))
                    Button(action: {
                        let eventStore = EKEventStore()
                        let newReminder: EKReminder = EKReminder(eventStore: eventStore)
                        
                        newReminder.title = title
                        newReminder.calendar = eventStore.defaultCalendarForNewReminders()
                            newReminder.dueDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: selectionDate)
                        
                        do{
                            try eventStore.save(newReminder, commit: true)
                            title = ""
                        }catch let error{
                            print(error)
                        }
                        
                    }) {
                        Text("登録")
                    }
                }
                Divider()
                Text("authorizationStatus:\(authorizationStatus)")
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
