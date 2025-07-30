//
//  SettingsView.swift
//  PUT DOWN THE PHONE
//
//  Created by Marwan Nakhaleh on 6/14/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsModel

    var body: some View {
        NavigationView {
            Form {
                VacationModeSection()

                IntervalSection()   

                AngerPhrasesSection()

                ActiveHoursSection()

                SaveButtonSection()
            }
            .navigationTitle("Settings")
        }
    }
}
