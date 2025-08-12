//
//  ReactionPaneView.swift
//  harukake
//
//  Presentation層 - Component
//  SDキャラ＋吹き出しコメント表示コンポーネント
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// SDキャラクター＋吹き出し表示コンポーネント
struct ReactionPaneView: View {
    let reaction: MiniReaction
    private let bundle: Bundle = .main
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // SDキャラクター画像（左側）
            characterImage
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .accessibilityHidden(true)
            
            // 吹き出しコメント（右側）
            SpeechBubble(text: reaction.text)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .frame(minHeight: 72)
        .zIndex(1)
        .compositingGroup()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(characterName)。\(reaction.text)")
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.easeOut(duration: 0.2), value: reaction.text)
    }
    
    /// キャラクター名を取得
    private var characterName: String {
        return reaction.characterID.displayName
    }
    
    /// デバイスに応じた画像高さ
    private var imageHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 72 : 64
    }
    
    /// キャラクター画像のViewBuilder
    @ViewBuilder
    private var characterImage: some View {
        let imageName = AssetImageValidator.safeImageName(for: reaction.characterID)
        
        if let uiImage = UIImage(named: imageName, in: bundle, with: nil) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onAppear {
                    DebugLogger.logUIAction("SD character image loaded: \(imageName)")
                }
        } else {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .background(Color.clear)
                .onAppear {
                    print("⚠️ not found:", imageName, bundle.bundleURL)
                    DebugLogger.logError("⚠️ SD character image not found: \(imageName), bundle: \(bundle.bundleURL)")
                }
        }
    }
}

/// 吹き出しコンポーネント
struct SpeechBubble: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .lineLimit(1)
                .truncationMode(.tail)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundStyle(.primary)
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
                
                // 左側のテール（三角形）
                Triangle()
                    .fill(.regularMaterial)
                    .frame(width: 6, height: 8)
                    .offset(x: -3)
            }
        )
    }
}

/// 三角形のテール
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    VStack(spacing: 20) {
        ReactionPaneView(
            reaction: MiniReaction(characterID: .reina, text: "節約上手だね！")
        )
        
        ReactionPaneView(
            reaction: MiniReaction(characterID: .hikari, text: "今日も記録お疲れさまでした！とても長いコメントの場合はどうなるかテスト")
        )
    }
    .padding()
}
