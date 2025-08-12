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
    @EnvironmentObject var appState: AppStateObservable
    @StateObject private var bubbleVM = HomeBubbleVM()
    @State private var showingRecord = false
    @State private var showingAnalytics = false
    @State private var showingStory = false
    @State private var showingSettings = false
    @State private var showingMessages = false
    @State private var showingMissions = false
    @State private var showingPresents = false

    var body: some View {
        ZStack {
            // 背景（タップ判定付き）
            CGBackgroundView(image: cgController.currentImageName)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    DebugLogger.logUIAction("Background tapped")
                    bubbleVM.showRandomBubble()
                }
            
            // 緊急復旧：全要素を直接配置
            VStack(spacing: 0) {
                // 上部：TopHUDとPresentButton
                HStack {
                    TopHUD()
                        .environmentObject(appState)
                    
                    Spacer()
                    
                    PresentButton(unreadCount: 0) {
                        DebugLogger.logUIAction("Opening PresentBoxSheet from PresentButton")
                        showingPresents = true
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 50)
                
                // 中央：サイドボタン
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        CircleButtonSmall(icon: "bubble.left.and.bubble.right", title: "メッセージ") {
                            DebugLogger.logUIAction("Opening MessagesSheet from LeftShortcuts")
                            showingMessages = true
                        }
                        
                        CircleButtonSmall(icon: "target", title: "ミッション") {
                            DebugLogger.logUIAction("Opening MissionsSheet from LeftShortcuts")
                            showingMissions = true
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.top, 20)
                    
                    Spacer()
                }
                
                // 下部：BottomMenuBar
                BottomMenuBar(
                    showingAnalytics: $showingAnalytics,
                    showingStory: $showingStory,
                    showingSettings: $showingSettings
                )
            }
            
            // 右下固定のRecordFAB
            .overlay(alignment: .bottomTrailing) {
                RecordFAB {
                    DebugLogger.logUIAction("Opening RecordView from FAB")
                    showingRecord = true
                }
            }
            
            // 吹き出し表示（画面下1/3領域）
            .overlay(alignment: .bottom) {
                if bubbleVM.isShowing, let bubble = bubbleVM.currentBubble {
                    VStack {
                        Spacer()
                        
                        SpeechBubbleView(
                            text: bubble.text,
                            side: bubble.side
                        ) {
                            bubbleVM.hide()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120) // 下部バー + マージン
                        .transition(.asymmetric(
                            insertion: .scale(
                                scale: 0.8, 
                                anchor: bubble.side == .left ? .bottomLeading : .bottomTrailing
                            )
                                .combined(with: .opacity)
                                .animation(.spring(response: 0.4, dampingFraction: 0.8)),
                            removal: .scale(
                                scale: 0.9, 
                                anchor: bubble.side == .left ? .bottomLeading : .bottomTrailing
                            )
                                .combined(with: .opacity)
                                .animation(.easeOut(duration: 0.2))
                        ))
                    }
                }
            }
        }
        .task {
            await cgController.preload()
            cgController.updateForTimeOfDay()
        }
        .onAppear {
            appState.loadInitialData()
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
            Text("Messages - 未実装")
        }
        .sheet(isPresented: $showingMissions) {
            Text("Missions - 未実装")
        }
        .sheet(isPresented: $showingPresents) {
            PresentBoxSheet()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppStateObservable.mock())
}
