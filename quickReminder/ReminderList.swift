//
//  ReminderList.swift
//  quickReminder
//
//  Created by hato on 2021/03/17.
//

import SwiftUI
import EventKit

struct ReminderList: View {
    var reminders: [EKReminder]

    var body: some View {
        List {
            ForEach(reminders, id: \.calendarItemIdentifier){ reminder in
                ReminderRow(reminder: reminder)
            }
        }
    }
}

//struct ReminderList_Previews: PreviewProvider {
//    static var previews: some View {
//        ReminderList()
//    }
//}
