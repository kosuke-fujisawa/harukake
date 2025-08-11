//
//  PresentButton.swift
//  harukake
//
//  このプロジェクトは CC BY-NC 4.0 ライセンスの下でライセンスされています。
//  プロジェクトルートのLICENSEファイルで完全なライセンス情報を参照してください。
//
//  非営利使用のみ。
//

import SwiftUI

/// プレゼント機能へのアクセスボタン
/// RecordFABと縦スタック配置され、拡張ヒット領域と未読数バッジ表示に対応
struct PresentButton: View {
    let unreadCount: Int
    let action: () -> Void
    
    /// 見た目のボタンサイズ（FABとの統一感）
    private var visualSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 52 : 48
    }
    
    /// タップ判定のヒット領域サイズ（操作性向上）
    private var hitSize: CGFloat { 68 }
    
    var body: some View {
        Button(action: action) {
            // 透明のヒット領域で見た目より大きなタップ判定を提供
            ZStack(alignment: .topTrailing) {
                Color.clear
                    .frame(width: hitSize, height: hitSize)
                    .contentShape(RoundedRectangle(cornerRadius: hitSize / 4))
                
                // 実際の見た目のボタン
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.yellow)
                    .frame(width: visualSize, height: visualSize)
                    .overlay(
                        Image(systemName: "gift.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.black)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(.black, lineWidth: 2)
                    )
                
                // 未読数バッジ
                if unreadCount > 0 {
                    Text(unreadCount > 9 ? "9+" : "\(unreadCount)")
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(.red))
                        .offset(x: 10, y: -10)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("プレゼント")
        .accessibilityHint(unreadCount > 0 ? "未受取のプレゼントが\(unreadCount)個あります" : "プレゼントボックスを開く")
        .accessibilityValue(unreadCount > 0 ? "\(unreadCount)個の未読" : "")
    }
}

/// プレゼントボックス画面のプレースホルダー
/// 将来的に本格実装予定
struct PresentBoxSheet: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "gift.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Color.accentColor)
                
                Text("🎁 プレゼントボックス")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("プレゼント機能は\n開発中です...")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("プレゼント")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview("PresentButton") {
    VStack(spacing: 16) {
        PresentButton(unreadCount: 0) {
            print("プレゼントボタン（未読なし）がタップされました")
        }
        
        PresentButton(unreadCount: 3) {
            print("プレゼントボタン（未読3個）がタップされました")
        }
        
        PresentButton(unreadCount: 12) {
            print("プレゼントボタン（未読12個→9+）がタップされました")
        }
    }
    .padding()
    .background(Color.gray.opacity(0.3))
}

#Preview("PresentBoxSheet") {
    PresentBoxSheet()
}
