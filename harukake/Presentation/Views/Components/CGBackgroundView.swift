//
//  CGBackgroundView.swift
//  harukake
//
//  このプロジェクトは CC BY-NC 4.0 ライセンスの下でライセンスされています。
//  プロジェクトルートのLICENSEファイルで完全なライセンス情報を参照してください。
//
//  非営利使用のみ。
//

import SwiftUI
import UIKit

/// 背景CGを表示するビューコンポーネント
/// 端末サイズに応じたスケーリングとトリミング制御を行う
struct CGBackgroundView: View {
    let image: String
    
    var body: some View {
        ZStack {
            // フォールバック背景色
            Color(.systemBackground)
                .ignoresSafeArea()
            
            // メイン背景CG
            if let uiImage = UIImage(named: image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay {
                        // 上下に薄いグラデーションを追加（UI可読性向上）
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.10),
                                Color.clear,
                                Color.black.opacity(0.20)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .allowsHitTesting(false)
                    }
                    .transition(.opacity.animation(.easeInOut(duration: 0.25)))
                    .accessibilityHidden(true)
                    .allowsHitTesting(false)
            } else {
                // 画像が読み込めない場合のフォールバック
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.6),
                            Color.purple.opacity(0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .ignoresSafeArea()
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.system(size: 48))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("背景画像を読み込み中...")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .accessibilityHidden(true)
                    .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    CGBackgroundView(image: "cg_home_default")
}
