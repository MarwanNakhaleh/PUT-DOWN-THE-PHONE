//
//  FirstLaunchSettingsView.swift
//  PUT DOWN THE PHONE
//
//  Created by Marwan Nakhaleh on 5/30/25.
//

import SwiftUI

struct FirstLaunchSettingsView: View {
    @EnvironmentObject var settings: SettingsModel
    @State private var showingMainMenu = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Welcome header
                VStack(spacing: 10) {
                    Image(systemName: "phone.down")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    
                    Text("Welcome to PUT DOWN THE PHONE")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Let's set up your angry reminders to help you put your phone down!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                // Settings form
                Form {
                    VacationModeSection()
                    IntervalSection()   
                    AngerPhrasesSection()
                    ActiveHoursSection()
                    
                    Section {
                        Button(action: {
                            completeFirstLaunchSetup()
                        }) {
                            Text("Save Settings & Continue")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .navigationTitle("Initial Setup")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $showingMainMenu) {
            MainMenuView()
                .environmentObject(settings)
        }
    }
    
    private func completeFirstLaunchSetup() {
        // Save settings
        DeviceActivityScheduler.shared.apply(settings: settings)
        
        // Mark first launch as completed
        FirstLaunchManager.markFirstLaunchCompleted()
        
        // Show main menu
        showingMainMenu = true
    }
}

#Preview {
    FirstLaunchSettingsView()
        .environmentObject(SettingsModel())
} 