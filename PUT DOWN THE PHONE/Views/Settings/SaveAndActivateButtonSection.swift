import SwiftUI

/// A form section that persists the current settings *and* immediately activates the monitoring schedule.
struct SaveAndActivateButtonSection: View {
    @EnvironmentObject var settings: SettingsModel

    var body: some View {
        Section {
            Button("Save & Activate") {
                // Mark the configuration as active and apply it.
                settings.isActive = true
                DeviceActivityScheduler.shared.apply(settings: settings)
            }
            .disabled(settings.vacationMode)
        }
    }
} 