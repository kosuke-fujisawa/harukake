//
//  RightUtilities.swift
//  harukake
//
//  このプロジェクトは CC BY-NC 4.0 ライセンスの下でライセンスされています。
//  プロジェクトルートのLICENSEファイルで完全なライセンス情報を参照してください。
//
//  非営利使用のみ。
//

import SwiftUI

/// ホーム画面右上のユーティリティボタン群
/// 設定、ヘルプなどへのアクセスを提供
struct RightUtilities: View {
    @Binding var showingSettings: Bool
    @State private var showingHelp = false
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                DebugLogger.logUIAction("Opening SettingsSheet from RightUtilities")
                showingSettings = true
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(
                        Circle()
                            .strokeBorder(.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 16)
            .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .sheet(isPresented: $showingHelp) {
            HelpView()
        }
    }
}

/// ユーティリティボタンの個別コンポーネント
struct UtilityButton: View {
    let icon: String
    let iconColor: Color
    let backgroundColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 44, height: 44)
                .background(backgroundColor, in: Circle())
                .overlay(
                    Circle()
                        .strokeBorder(.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
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
        .accessibilityLabel(icon == "questionmark.circle.fill" ? "ヘルプ" : "設定")
    }
}

/// ヘルプ表示用の簡易ビュー
struct HelpView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("❓ ヘルプ")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 16) {
                    HelpItem(
                        title: "記録の仕方",
                        description: "下部メニューの「記録」から収支を入力できます"
                    )
                    
                    HelpItem(
                        title: "目標達成まで",
                        description: "100万円を目標に、コツコツ記録を続けましょう"
                    )
                    
                    HelpItem(
                        title: "キャラクター",
                        description: "記録を続けることで新しいストーリーが解放されます"
                    )
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("ヘルプ")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

/// ヘルプアイテムの個別コンポーネント
struct HelpItem: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        RightUtilities(showingSettings: .constant(false))
            .padding()
    }
}
