//
//  ReminderRow.swift
//  quickReminder
//
//  Created by hato on 2021/03/17.
//

import SwiftUI
import EventKit

struct ReminderRow: View {
    var reminder: EKReminder
    
    var body: some View {
        VStack(alignment:.leading ){
            Text("Title:\(reminder.title ?? "unknown")")
                .padding(2)
            Text("Date:\(DateUtils.stringFromDate(date: reminder.dueDateComponents?.date ?? Date(), format: "yyyy/MM/dd HH:mm:ss"))")
                .padding(2)
        }
    }
}

struct ReminderRow_Previews: PreviewProvider {
    static var model = ModelData()
    static var sample = SampleReminder()

    static var previews: some View {
        ReminderRow(reminder: SampleReminder.makeSampleReminder())
    }
}
