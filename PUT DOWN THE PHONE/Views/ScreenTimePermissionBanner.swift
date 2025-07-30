//
//  ScreenTimePermissionBanner.swift
//  PUT DOWN THE PHONE
//
//  Shows an explanatory banner plus a Settings link when Screen Time /
//  Family-Controls permission has been denied.
//
//  Created by ChatGPT on 7/29/25.
//

import SwiftUI
import FamilyControls
import UIKit

/// Displays only when the user previously denied Screen Time / Family Controls
/// authorization. Tapping the button jumps straight to the Settings page where
/// the permission toggle can be enabled.
struct ScreenTimePermissionBanner: View {
    @State private var showingSettings = false // not strictly necessary but handy if we add alerts later

    private var isDenied: Bool {
        AuthorizationCenter.shared.authorizationStatus == .denied
    }

    var body: some View {
        if isDenied {
            VStack(alignment: .leading, spacing: 12) {
                Text("Screen Time Access Needed")
                    .font(.headline)

                Text("Enable Screen Time access in Settings so we can monitor usage and remind you to put the phone down.")
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)

                Button("Open Settings") {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color.yellow.opacity(0.2))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

#Preview {
    ScreenTimePermissionBanner()
}
