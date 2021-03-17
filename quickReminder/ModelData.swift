//
//  ModelData.swift
//  quickReminder
//
//  Created by hato on 2021/03/17.
//

import Foundation
import Combine
import EventKit

final class ModelData: ObservableObject {
    @Published var sampleReminder: EKReminder
    
    init() {
        let a = EKReminder()
        a.title = "sampleReminder"
        sampleReminder = a
    }
}
