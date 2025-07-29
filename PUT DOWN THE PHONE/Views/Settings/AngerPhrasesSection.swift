//
//  AngerPhrasesSection.swift
//  PUT DOWN THE PHONE
//
//  Created by Marwan Nakhaleh on 6/14/25.
//


import SwiftUI

struct AngerPhrasesSection: View {
    @EnvironmentObject var settings: SettingsModel

    var body: some View {
        Section(header: Text("Anger Phrases")) {
            ForEach(Array(settings.angerPhrases.enumerated()), id: \.offset) { idx, _ in
                TextField(
                    "Level \(idx+1)",
                    text: Binding(
                        get: { settings.angerPhrases[idx] },
                        set: { settings.angerPhrases[idx] = $0 }
                    )
                )
            }
        }
    }
}
