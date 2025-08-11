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
    @StateObject private var cgController = CGBackgroundController()
    @State private var showingRecord = false
    @State private var showingAnalytics = false
    @State private var showingStory = false
    @State private var showingSettings = false
    @State private var showingMessages = false
    @State private var showingMissions = false

    var body: some View {
        ZStack {
            // 1) 背景CG（常時表示）
            CGBackgroundView(image: cgController.currentImageName)
                .ignoresSafeArea()
            
            // 2) 立ち絵レイヤー（今回はスキップ）
            // CharacterLayerView()
            
            // 3) UIオーバーレイ
            VStack(spacing: 0) {
                // 上部ステータスバー
                TopStatusBar()
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                Spacer()
            }
            
            // 左側ショートカット
            LeftShortcuts(
                showingMessages: $showingMessages,
                showingMissions: $showingMissions
            )
            .padding(.leading, 12)
            .padding(.top, 72)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // 右上ユーティリティ
            RightUtilities(showingSettings: $showingSettings)
                .padding(.trailing, 12)
                .padding(.top, 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
            // 4) コメントオーバーレイ（将来実装）
            // CommentOverlay()
        }
        .safeAreaInset(edge: .bottom) {
            BottomMenuBar(
                showingRecord: $showingRecord,
                showingAnalytics: $showingAnalytics,
                showingStory: $showingStory,
                showingSettings: $showingSettings
            )
        }
        .task {
            await cgController.preload()
            cgController.updateForTimeOfDay()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
            cgController.handleMemoryWarning()
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
