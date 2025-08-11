//
//  RecordFAB.swift
//  harukake
//
//  このプロジェクトは CC BY-NC 4.0 ライセンスの下でライセンスされています。
//  プロジェクトルートのLICENSEファイルで完全なライセンス情報を参照してください。
//
//  非営利使用のみ。
//

import SwiftUI

/// 右下固定配置の記録用フローティングアクションボタン
/// デバイス別レスポンシブサイズ対応・下部バー衝突回避
struct RecordFAB: View {
    let action: () -> Void
    
    @State private var isPressed = false
    
    /// デバイスに適した見た目サイズ
    private var visualSize: CGFloat {
        UIConstants.appropriateFABSize
    }
    
    /// タップ判定のヒット領域サイズ（+12pt拡張）
    private var hitSize: CGFloat {
        visualSize + UIConstants.fabHitPadding
    }
    
    /// 右マージン（推奨20pt）
    private var rightMargin: CGFloat {
        20
    }
    
    /// 下マージン（下部バーとの間隔を考慮した値）
    private var bottomMargin: CGFloat {
        UIConstants.bottomBarHeight + 20
    }
    
    var body: some View {
        Button {
            // 軽ハプティクフィードバック
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        } label: {
            // 透明のヒット領域で見た目より大きなタップ判定を提供
            ZStack {
                Color.clear
                    .frame(width: hitSize, height: hitSize)
                    .contentShape(Circle())
                
                // 実際の見た目のFAB
                Circle()
                    .fill(Color.accentColor.opacity(isPressed ? 1.0 : 0.9))
                    .frame(width: visualSize, height: visualSize)
                    .overlay(
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundStyle(.white)
                    )
                    .shadow(radius: 6, y: 3)
                    .scaleEffect(isPressed ? 0.96 : 1.0)
                    .animation(.spring(response: 0.18, dampingFraction: 0.9), value: isPressed)
            }
        }
        .buttonStyle(.plain)
        .padding(.trailing, rightMargin)
        .padding(.bottom, bottomMargin)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .hoverEffect(.lift)
        .accessibilityLabel("記録する")
        .accessibilityHint("家計簿の記録画面を開く")
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        VStack {
            Spacer()
            HStack {
                Spacer()
                RecordFAB {
                    print("記録FABがタップされました")
                }
            }
        }
    }
}
