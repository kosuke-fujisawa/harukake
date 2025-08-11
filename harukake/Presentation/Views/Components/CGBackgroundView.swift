//
//  CGBackgroundView.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

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
                    .clipped()
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
                    }
                    .transition(.opacity.animation(.easeInOut(duration: 0.25)))
                    .accessibilityHidden(true)
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
            }
        }
    }
}

#Preview {
    CGBackgroundView(image: "cg_home_default")
}
