//
//  StoryView.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// LiteScript再生ビュー
/// 背景、立ち絵（3レーン）、セリフウィンドウ、選択肢UIを提供
struct StoryView: View {
    @StateObject private var player = StoryPlayer()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 背景
            backgroundView
            
            // 立ち絵（3レーン）
            characterLayerView
            
            // UI下部
            VStack {
                Spacer()
                
                if let choices = player.pendingChoice {
                    choiceButtonsView(choices)
                } else if let line = player.currentLine {
                    dialogueView(line)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            DebugLogger.logUIAction("StoryView appeared")
            loadSampleScript()
        }
    }
    
    /// 背景表示
    private var backgroundView: some View {
        Group {
            if let uiImage = UIImage(named: player.stage.background) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                // 背景画像が見つからない場合のデフォルト表示
                if player.stage.background != "default" {
                    Image("cg_home_default")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .onAppear {
                            print("Background image not found: \(player.stage.background), using default")
                        }
                } else {
                    // デフォルト画像も見つからない場合
                    Color.black
                        .onAppear {
                            print("Default background image not found")
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .background(Color.black)
    }
    
    /// 立ち絵レイヤー（3レーン配置）
    private var characterLayerView: some View {
        ZStack {
            // 左レーン
            if let leftChar = player.stage.characters[.left] {
                characterView(leftChar)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 50)
            }
            
            // 中央レーン
            if let centerChar = player.stage.characters[.center] {
                characterView(centerChar)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            // 右レーン
            if let rightChar = player.stage.characters[.right] {
                characterView(rightChar)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 50)
            }
        }
        .animation(.easeOut(duration: 0.18), value: player.stage.characters)
    }
    
    /// キャラクター表示
    private func characterView(_ character: CharacterDisplay) -> some View {
        VStack(spacing: 0) {
            // 感情マーク
            if let emote = character.emote {
                Text(emote)
                    .font(.title)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.bouncy, value: emote)
            }
            
            // 立ち絵（画像欠落時はダミー表示）
            Group {
                if let uiImage = UIImage(named: "\(character.name)_\(character.expression)") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    // 画像が見つからない場合のダミー表示
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray.opacity(0.3))
                        .overlay {
                            VStack {
                                Text(character.name)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("(\(character.expression))")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onAppear {
                            print("Image not found: \(character.name)_\(character.expression)")
                        }
                }
            }
            .frame(maxHeight: 400)
            .background(Color.clear)
        }
    }
    
    /// セリフウィンドウ
    private func dialogueView(_ line: (speaker: String, text: String)) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(line.speaker)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(line.text)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
        .padding(.bottom, 20)
        .accessibilityLabel("\(line.speaker)。\(line.text)")
        .onTapGesture {
            player.step()
        }
    }
    
    /// 選択肢ボタン群
    private func choiceButtonsView(_ choices: [ChoiceItem]) -> some View {
        VStack(spacing: 12) {
            ForEach(Array(choices.enumerated()), id: \.offset) { index, choice in
                Button {
                    player.choose(index)
                } label: {
                    Text(choice.title)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
                .accessibilityLabel("選択肢\(index + 1): \(choice.title)")
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    /// サンプルスクリプトの読み込み
    private func loadSampleScript() {
        let sampleScript = """
        # サンプルLiteScript（画像欠落テスト含む）
        [BG cg_home_default]
        [SHOW ひかり L neutral]
        [SHOW れいな R smile]
        
        ひかり: 今日は固定費の見直し、やってみる？
        ? どうする？
        - そうだね -> agree
        - やってみるよ -> agree
        
        ::agree
        れいな: うん、一緒に頑張ろ。
        [EMOTE ひかり 💡]
        ひかり: よろしくお願いします！
        [WAIT 2.0]
        システム: 擬似選択肢とエラーハンドリングのテストが完了しました。
        
        [END]
        """
        
        player.loadScript(sampleScript)
    }
}

#Preview {
    StoryView()
}
