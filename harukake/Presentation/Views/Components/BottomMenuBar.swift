//
//  BottomMenuBar.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// ホーム画面下部のメインメニューバー
/// 記録、分析、ストーリー、設定へのアクセスを提供
struct BottomMenuBar: View {
    @Binding var showingRecord: Bool
    @Binding var showingAnalytics: Bool
    @Binding var showingStory: Bool
    @Binding var showingSettings: Bool
    
    var body: some View {
        HStack(spacing: 32) {
            BottomItem(icon: "square.and.pencil", title: "記録") {
                DebugLogger.logUIAction("Opening RecordSheet from BottomMenuBar")
                showingRecord = true
            }
            
            BottomItem(icon: "chart.bar.xaxis", title: "分析") {
                DebugLogger.logUIAction("Opening AnalyticsSheet from BottomMenuBar")
                showingAnalytics = true
            }
            
            BottomItem(icon: "book", title: "ストーリー") {
                DebugLogger.logUIAction("Opening StorySheet from BottomMenuBar")
                showingStory = true
            }
            
            BottomItem(icon: "gearshape", title: "設定") {
                DebugLogger.logUIAction("Opening SettingsSheet from BottomMenuBar")
                showingSettings = true
            }
        }
        .frame(height: 72)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .overlay(
            Rectangle()
                .fill(.white.opacity(0.1))
                .frame(height: 1),
            alignment: .top
        )
    }
}

/// 下部メニューアイテムの個別コンポーネント
struct BottomItem: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    .frame(height: 24)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            action()
        }
        .accessibilityLabel(title)
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        VStack {
            Spacer()
            BottomMenuBar(
                showingRecord: .constant(false),
                showingAnalytics: .constant(false),
                showingStory: .constant(false),
                showingSettings: .constant(false)
            )
        }
    }
}
