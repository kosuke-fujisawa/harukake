//
//  LeftShortcuts.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// ホーム画面左側のショートカットボタン群
/// メッセージ、ミッション、Tipsへのアクセスを提供
struct LeftShortcuts: View {
    @Binding var showingMessages: Bool
    @Binding var showingMissions: Bool
    @State private var showingTips = false
    
    var body: some View {
        VStack(spacing: 12) {
            CircleButton(icon: "bubble.left.and.bubble.right", title: "メッセージ", badge: 1) {
                DebugLogger.logUIAction("Opening MessagesSheet from LeftShortcuts")
                showingMessages = true
            }
            
            CircleButton(icon: "target", title: "ミッション", badge: 0) {
                DebugLogger.logUIAction("Opening MissionsSheet from LeftShortcuts")
                showingMissions = true
            }
            
            CircleButton(icon: "lightbulb", title: "Tips", badge: 0) {
                DebugLogger.logUIAction("Opening TipsSheet from LeftShortcuts")
                showingTips = true
            }
            
            Spacer()
        }
        .padding(.leading, 12)
        .padding(.top, 72)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sheet(isPresented: $showingTips) {
            TipsView()
        }
    }
}

/// 円形ボタンの個別コンポーネント
struct CircleButton: View {
    let icon: String
    let title: String
    let badge: Int
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Circle()
                                .strokeBorder(.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .overlay(
                            Image(systemName: icon)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                        )
                    
                    // 通知バッジ
                    if badge > 0 {
                        Circle()
                            .fill(.red)
                            .frame(width: 10, height: 10)
                            .offset(x: 6, y: -6)
                            .overlay(
                                Circle()
                                    .strokeBorder(.white, lineWidth: 1)
                                    .frame(width: 10, height: 10)
                                    .offset(x: 6, y: -6)
                            )
                    }
                }
                
                // ラベル
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                    .frame(width: 72)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
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
        .accessibilityHint(badge > 0 ? "新しい通知があります" : "")
    }
}

/// Tips表示用の簡易ビュー
struct TipsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("💡 お役立ちTips")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("お役立ちTips機能は\n開発中です...")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Tips")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        LeftShortcuts(
            showingMessages: .constant(false),
            showingMissions: .constant(false)
        )
        .padding()
    }
}
