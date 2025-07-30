import SwiftUI

/// A form section that persists the current settings *and* immediately activates the monitoring schedule.
struct SaveAndActivateButtonSection: View {
    @EnvironmentObject var settings: SettingsModel
    /// Allows this view to dismiss itself when the user taps **Save & Activate**.
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Section {
            Button("Save & Activate") {
                // Mark the configuration as active and apply it.
                settings.isActive = true
                DeviceActivityScheduler.shared.apply(settings: settings)
                // Close the Settings sheet and return to the main menu.
                dismiss()
            }
            .disabled(settings.vacationMode)
        }
    }
} 