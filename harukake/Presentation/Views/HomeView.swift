//
//  HomeView.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

struct HomeView: View {
    @State private var showingRecord = false
    @State private var showingAnalytics = false
    @State private var showingStory = false
    @State private var showingSettings = false
    @State private var showingMessages = false
    @State private var showingMissions = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // ヘッダー（ハンバーガーメニューと設定）
                HStack {
                    Button {
                        DebugLogger.logUIAction("Opening MessagesSheet")
                        showingMessages = true
                    } label: {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.title2)
                    }

                    Spacer()

                    Button {
                        DebugLogger.logUIAction("Opening MissionsSheet")
                        showingMissions = true
                    } label: {
                        Image(systemName: "target")
                            .font(.title2)
                    }

                    Button {
                        DebugLogger.logUIAction("Opening SettingsSheet")
                        showingSettings = true
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)

                // メインコンテンツエリア
                VStack(spacing: 20) {
                    Text("遥かなる家計管理の道のり")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text("今日も記録を続けて、\n目標の100万円を目指そう！")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)

                    // 現在の進行状況表示
                    VStack(spacing: 10) {
                        Text("現在の貯金額")
                            .font(.headline)

                        Text("¥0")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)

                        ProgressView(value: 0.0, total: 1000000.0)
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(height: 10)
                            .padding(.horizontal, 40)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(15)
                }

                Spacer()

                // 下部ナビゲーションバー
                HStack(spacing: 0) {
                    NavigationButton(
                        icon: "square.and.pencil",
                        title: "記録",
                        action: {
                            DebugLogger.logUIAction("Opening RecordSheet")
                            showingRecord = true
                        }
                    )

                    NavigationButton(
                        icon: "chart.bar.xaxis",
                        title: "分析",
                        action: {
                            DebugLogger.logUIAction("Opening AnalyticsSheet")
                            showingAnalytics = true
                        }
                    )

                    NavigationButton(
                        icon: "book",
                        title: "ストーリー",
                        action: {
                            DebugLogger.logUIAction("Opening StorySheet")
                            showingStory = true
                        }
                    )

                    NavigationButton(
                        icon: "gear",
                        title: "設定",
                        action: {
                            DebugLogger.logUIAction("Opening SettingsSheet")
                            showingSettings = true
                        }
                    )
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(20)
            }
            .padding()
            .navigationTitle("ホーム")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingRecord) {
            RecordView()
        }
        .sheet(isPresented: $showingAnalytics) {
            AnalyticsView()
        }
        .sheet(isPresented: $showingStory) {
            StoryView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingMessages) {
            MessagesView()
        }
        .sheet(isPresented: $showingMissions) {
            MissionsView()
        }
    }
}

struct NavigationButton: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundStyle(.primary)
    }
}

struct MessagesView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("💬 キャラクターメッセージ")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("キャラクターからのメッセージ機能は\n開発中です...")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .navigationTitle("メッセージ")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MissionsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("🎯 ミッション")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("ミッション・チャレンジ機能は\n開発中です...")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .navigationTitle("ミッション")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomeView()
}
