//
//  MainMenuView.swift
//  PUT DOWN THE PHONE
//
//  Created by Marwan Nakhaleh on 5/30/25.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var settings: SettingsModel
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // App Title
                VStack(spacing: 10) {
                    Image(systemName: "phone.down")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    
                    Text("PUT DOWN THE PHONE")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 50)
                
                // Show Screen Time permission explanation if the user previously denied access.
                ScreenTimePermissionBanner()

                Spacer()
                
                // Status Section
                VStack(spacing: 15) {
                    StatusCard()
                        .environmentObject(settings)
                    
                    Text("Monitoring is \(settings.isActive ? "ACTIVE" : "INACTIVE")")
                            .font(.headline)
                            .foregroundColor(.green)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 20) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Label("Settings", systemImage: "gear")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        toggleMonitoring()
                    }) {
                        Label(settings.isActive ? "Stop Monitoring" : "Start Monitoring", 
                              systemImage: settings.isActive ? "stop.circle" : "play.circle")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(settings.isActive ? Color.red : Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
            .navigationTitle("Main Menu")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(settings)
        }
        // Automatically align the monitoring state with the current time when the
        // view appears (e.g.  when returning from Settings or launching the app).
        .onAppear {
            autoUpdateMonitoringState()
        }
    }
    
    private func toggleMonitoring() {
        settings.isActive.toggle()
        DeviceActivityScheduler.shared.apply(settings: settings)
    }

    /// Ensures `settings.isActive` reflects whether **now** falls within today's
    /// configured "active hours" window. If it changes, the scheduler is
    /// (re)applied so the underlying system monitoring matches the UI.
    private func autoUpdateMonitoringState() {
        // Skip automatic changes while Vacation Mode is on. We *never* want to
        // *start* monitoring during vacation, but we also should not cancel an
        // existing repeating schedule (that would prevent future days from
        // activating once vacation mode is turned off again). Therefore, we
        // simply return without altering anything.
        if settings.vacationMode {
            return
        }

        let calendar = Calendar.current
        let now = Date()
        let todayIndex = calendar.component(.weekday, from: now) - 1 // 0-based index
        let todaySymbol = calendar.weekdaySymbols[todayIndex]

        guard let todaySettings = settings.days.first(where: { $0.weekday == todaySymbol }) else {
            return
        }

        // Build concrete Date instances for today's start & end times.
        let startComponents = calendar.dateComponents([.hour, .minute], from: todaySettings.startTime)
        let endComponents   = calendar.dateComponents([.hour, .minute], from: todaySettings.endTime)

        guard let startHour = startComponents.hour,
              let startMinute = startComponents.minute,
              let endHour = endComponents.hour,
              let endMinute = endComponents.minute,
              let startToday = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: now),
              var endToday   = calendar.date(bySettingHour: endHour,   minute: endMinute,   second: 0, of: now) else {
            return
        }

        // If the end time precedes the start time (window spans midnight), push
        // the end date to tomorrow.
        if endToday <= startToday {
            endToday = calendar.date(byAdding: .day, value: 1, to: endToday)!
        }

        let insideWindow = (startToday ... endToday).contains(now)

        // If we're *inside* the configured window and monitoring isn't yet
        // active (e.g. the user launched the app for the first time today), turn
        // it on so the schedule is registered with the system.  If we're
        // *outside* the window we leave the schedule as-is; the underlying
        // DeviceActivityCenter takes care of firing only during the interval
        // and because `repeats` is true it will automatically cover future
        // days.  Avoiding a "stop" here ensures the schedule remains in place
        // even when the user has closed the app.
        if insideWindow && !settings.isActive {
            settings.isActive = true
            DeviceActivityScheduler.shared.apply(settings: settings)
        }
    }
}

struct StatusCard: View {
    @EnvironmentObject var settings: SettingsModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Status")
                .font(.headline)
            
            HStack {
                Image(systemName: "clock")
                Text("Check interval: \(settings.intervalMinutes) minutes")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if !settings.vacationMode {
                HStack {
                    Image(systemName: "moon.zzz")
                    // Find the DaySettings that matches today's weekday using the user's
                    // current calendar and time-zone (Calendar.current).
                    let calendar = Calendar.current
                    // Apple calendars use 1 = Sunday, 7 = Saturday, so we subtract 1 for a
                    // zero-based index into `weekdaySymbols`.
                    let todayIndex = calendar.component(.weekday, from: Date()) - 1
                    let todaySymbol = calendar.weekdaySymbols[todayIndex]

                    if let todaySettings = settings.days.first(where: { $0.weekday == todaySymbol }) {
                        let startTime = formatTime(todaySettings.startTime)
                        let endTime = formatTime(todaySettings.endTime)
                        Text("Active from \(startTime) - \(endTime)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                HStack {
                    Image(systemName: "beach.umbrella")
                    Text("Vacation Mode is ON")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    MainMenuView()
        .environmentObject(SettingsModel())
} 
