//
//  ActiveHoursSection.swift
//  PUT DOWN THE PHONE
//
//  Created by Marwan Nakhaleh on 6/14/25.
//


import SwiftUI

struct ActiveHoursSection: View {
    @EnvironmentObject var settings: SettingsModel

    var body: some View {
        Section(header: Text("Active Hours")) {
            ForEach($settings.days) { $day in
                VStack(alignment: .leading) {
                    Text(day.weekday)
                        .font(.headline)
                    HStack {
                        DatePicker("Start", selection: $day.startTime, displayedComponents: .hourAndMinute)
                        DatePicker("End", selection: $day.endTime, displayedComponents: .hourAndMinute)
                    }
                }
            }
        }
    }
}
