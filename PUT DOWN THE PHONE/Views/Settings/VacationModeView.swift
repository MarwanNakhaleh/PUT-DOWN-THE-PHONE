//
//  VacationModeView.swift
//  PUT DOWN THE PHONE
//
//  Created by Marwan Nakhaleh on 6/14/25.
//

import SwiftUI

struct VacationModeSection: View {
    @EnvironmentObject var settings: SettingsModel

    var body: some View {
        Section(header: Text("Vacation Mode")) {
            Toggle("Vacation Mode", isOn: $settings.vacationMode)
        }
    }
}
