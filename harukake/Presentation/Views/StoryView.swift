//
//  StoryView.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

struct StoryView: View {
    var body: some View {
        NavigationView {
            List {
                Section("メイン Lv.1/100") {
                    StoryRow(title: "第1章「始まり」", isUnlocked: true, requirement: "")
                    StoryRow(title: "第2章「仲間たち」", isUnlocked: false, requirement: "Lv.5で解放")
                    StoryRow(title: "第3章「成長」", isUnlocked: false, requirement: "Lv.10で解放")
                }

                Section("サイド（ジュエル: 5💎）") {
                    StoryCharacterSection(character: "ひかり", stories: [
                        ("節約の基本", true, ""),
                        ("恋愛相談", false, "💎3")
                    ])

                    StoryCharacterSection(character: "れいな", stories: [
                        ("婚約の話", false, "💎3"),
                        ("家計管理術", false, "💎5")
                    ])

                    StoryCharacterSection(character: "まゆ", stories: [
                        ("起業の失敗", false, "💎3"),
                        ("借金返済", false, "💎5")
                    ])
                }
            }
            .navigationTitle("ストーリー")
            .onAppear {
                DebugLogger.logUIAction("StoryView appeared")
            }
        }
    }
}

struct StoryRow: View {
    let title: String
    let isUnlocked: Bool
    let requirement: String

    var body: some View {
        HStack {
            Image(systemName: isUnlocked ? "checkmark.circle.fill" : "lock.circle")
                .foregroundStyle(isUnlocked ? .green : .secondary)

            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(isUnlocked ? .primary : .secondary)
                if !requirement.isEmpty {
                    Text(requirement)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
    }
}

struct StoryCharacterSection: View {
    let character: String
    let stories: [(String, Bool, String)]

    var body: some View {
        DisclosureGroup("👤\(character)") {
            ForEach(Array(stories.enumerated()), id: \.offset) { _, story in
                StoryRow(title: story.0, isUnlocked: story.1, requirement: story.2)
            }
        }
    }
}

#Preview {
    StoryView()
}
