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
                
                Spacer()
                
                // Status Section
                VStack(spacing: 15) {
                    StatusCard()
                        .environmentObject(settings)
                    
                    if settings.isActive {
                        Text("Monitoring is ACTIVE")
                            .font(.headline)
                            .foregroundColor(.green)
                    } else {
                        Text("Monitoring is INACTIVE")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
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
    }
    
    private func toggleMonitoring() {
        settings.isActive.toggle()
        DeviceActivityScheduler.shared.apply(settings: settings)
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
                    if let firstDay = settings.days.first {
                        let startTime = formatTime(firstDay.startTime)
                        let endTime = formatTime(firstDay.endTime)
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
