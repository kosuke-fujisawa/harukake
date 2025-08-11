//
//  CircleButtonSmall.swift
//  harukake
//
//  このプロジェクトは CC BY-NC 4.0 ライセンスの下でライセンスされています。
//  プロジェクトルートのLICENSEファイルで完全なライセンス情報を参照してください。
//
//  非営利使用のみ。
//

import SwiftUI

/// ホーム画面左列用の小型円形ボタン
/// メッセージとミッション専用（Tips削除により使用）
struct CircleButtonSmall: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    /// 見た目のボタンサイズ
    private var diameter: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 52 : 48
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: diameter, height: diameter)
                    .overlay(
                        Circle()
                            .strokeBorder(.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    )
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isPressed)
                
                // ラベル
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                    .frame(width: 72, alignment: .center)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .accessibilityLabel(title)
    }
}

#Preview {
    VStack(spacing: 20) {
        CircleButtonSmall(icon: "bubble.left.and.bubble.right", title: "メッセージ") {
            print("メッセージボタンがタップされました")
        }
        
        CircleButtonSmall(icon: "target", title: "ミッション") {
            print("ミッションボタンがタップされました")
        }
    }
    .padding()
    .background(Color.blue.ignoresSafeArea())
}
