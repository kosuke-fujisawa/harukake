//
//  SpeechBubbleView.swift
//  harukake
//
//  Presentation層 - 吹き出しUIコンポーネント
//  左右対応のテール付き吹き出しを提供
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// 吹き出しUIコンポーネント（テール付き、左右対応）
struct SpeechBubbleView: View {
    let text: String
    let side: BubbleSide
    let onClose: () -> Void
    
    /// デバイス別最適化パラメーター
    private var maxWidth: CGFloat {
        // iPhone横: 画面の約60%、iPad: より余裕を持たせる
        return UIDevice.current.userInterfaceIdiom == .pad ? 280 : 220
    }
    
    private var tailSize: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 16 : 14
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if side == .right {
                Spacer()
            }
            
            // メイン吹き出し部分
            VStack(alignment: side == .left ? .leading : .trailing, spacing: 0) {
                // 吹き出し本体
                HStack {
                    Text(text)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.primary)
                        .lineLimit(3)
                        .multilineTextAlignment(side == .left ? .leading : .trailing)
                    
                    Spacer(minLength: 8)
                    
                    // 閉じるボタン
                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("閉じる")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: maxWidth)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                // テール部分
                HStack {
                    if side == .left {
                        TailShape()
                            .fill(.ultraThinMaterial)
                            .frame(width: tailSize, height: tailSize / 2)
                            .offset(x: 16)
                        Spacer()
                    } else {
                        Spacer()
                        TailShape()
                            .fill(.ultraThinMaterial)
                            .frame(width: tailSize, height: tailSize / 2)
                            .scaleEffect(x: -1, y: 1) // 右向きに反転
                            .offset(x: -16)
                    }
                }
            }
            
            if side == .left {
                Spacer()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text)
        .transition(.asymmetric(
            insertion: .scale(scale: 0.8).combined(with: .opacity),
            removal: .scale(scale: 0.9).combined(with: .opacity)
        ))
    }
}

/// 吹き出しのテール形状
struct TailShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 三角形のテール
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width * 0.3, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

#Preview("Left Bubble") {
    ZStack {
        Color.blue.opacity(0.3).ignoresSafeArea()
        
        VStack {
            Spacer()
            
            SpeechBubbleView(
                text: "きょうは固定費チェックの日だよ",
                side: .left
            ) {
                print("Bubble closed")
            }
            .padding(.bottom, 100)
        }
    }
}

#Preview("Right Bubble") {
    ZStack {
        Color.purple.opacity(0.3).ignoresSafeArea()
        
        VStack {
            Spacer()
            
            SpeechBubbleView(
                text: "新作見に行きたいけど…どうしよ",
                side: .right
            ) {
                print("Bubble closed")
            }
            .padding(.bottom, 100)
        }
    }
}

#Preview("Long Text") {
    ZStack {
        Color.green.opacity(0.3).ignoresSafeArea()
        
        VStack {
            Spacer()
            
            SpeechBubbleView(
                text: "レシピ見てたら材料費が気になっちゃった。手作りの方が節約になるかもしれないね。",
                side: .left
            ) {
                print("Bubble closed")
            }
            .padding(.bottom, 100)
        }
    }
}