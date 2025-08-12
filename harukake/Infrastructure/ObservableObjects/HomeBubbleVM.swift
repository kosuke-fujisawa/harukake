//
//  HomeBubbleVM.swift
//  harukake
//
//  Infrastructure層 - ObservableObjectラッパー
//  ホーム背景タップ時の吹き出し表示ロジックを管理
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation
import Combine
import SwiftUI

/// 吹き出しの表示位置
enum BubbleSide: CaseIterable {
    case left
    case right
}

/// 現在表示中の吹き出しデータ
struct DisplayedBubble: Equatable {
    let characterID: CharacterID
    let lineID: String
    let text: String
    let side: BubbleSide
}

/// 台詞データ構造
struct DialogueLine: Codable {
    let id: String
    let text: String
}

/// キャラクター別台詞データ
struct DialogueData: Codable {
    let hikari: [DialogueLine]
    let reina: [DialogueLine]
    let mayu: [DialogueLine]
    let makoto: [DialogueLine]
    let daichi: [DialogueLine]
    
    /// CharacterIDから対応する台詞配列を取得
    func lines(for characterID: CharacterID) -> [DialogueLine] {
        switch characterID {
        case .hikari: return hikari
        case .reina: return reina
        case .mayu: return mayu
        case .makoto: return makoto
        case .daichi: return daichi
        }
    }
}

/// ホーム背景タップ時の吹き出し表示を管理するViewModel
@MainActor
class HomeBubbleVM: ObservableObject {
    @Published var isShowing = false
    @Published var currentBubble: DisplayedBubble?
    
    private var lastCharacterID: CharacterID?
    private var lastLineID: String?
    private var cooldownUntil: Date = Date.distantPast
    private var hideTimer: Timer?
    private var dialogueData: DialogueData?
    
    init() {
        loadDialogueData()
    }
    
    /// Bundle内のJSONファイルから台詞データを読み込み
    private func loadDialogueData() {
        guard let url = Bundle.main.url(forResource: "bubble_lines", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            DebugLogger.logError("bubble_lines.json not found in Bundle")
            return
        }
        
        do {
            dialogueData = try JSONDecoder().decode(DialogueData.self, from: data)
            DebugLogger.logDataAction("Dialogue data loaded successfully")
        } catch {
            DebugLogger.logError("Failed to decode dialogue data", error: error)
        }
    }
    
    /// ランダムな吹き出しを表示（クールダウン制御付き）
    func showRandomBubble() {
        // クールダウン中は無視
        if Date() < cooldownUntil {
            return
        }
        
        // 台詞データが読み込まれていない場合は無視
        guard let dialogueData = dialogueData else {
            DebugLogger.logError("Dialogue data not available")
            return
        }
        
        // 既存の吹き出しを即閉じ
        if isShowing {
            hide()
        }
        
        // キャラクター選択（直前と同じキャラを避ける）
        let selectedCharacter = selectCharacter()
        
        // 台詞選択（直前と同じ台詞を避ける）
        let selectedLine = selectLine(for: selectedCharacter, from: dialogueData)
        
        // 表示位置選択（左右ランダム）
        let selectedSide = BubbleSide.allCases.randomElement() ?? .left
        
        // 吹き出し表示
        currentBubble = DisplayedBubble(
            characterID: selectedCharacter,
            lineID: selectedLine.id,
            text: selectedLine.text,
            side: selectedSide
        )
        
        // 状態更新
        lastCharacterID = selectedCharacter
        lastLineID = selectedLine.id
        isShowing = true
        
        // クールダウン設定（2秒）
        cooldownUntil = Date().addingTimeInterval(2.0)
        
        // 自動クローズタイマー設定（2.5秒）
        hideTimer?.invalidate()
        hideTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.hide()
            }
        }
        
        // ログ出力
        DebugLogger.logUIAction(
            "home.bubble_shown {character: \"\(selectedCharacter.rawValue)\", line_id: \"\(selectedLine.id)\"}"
        )
    }
    
    /// 吹き出しを非表示
    func hide() {
        hideTimer?.invalidate()
        hideTimer = nil
        
        withAnimation(.easeOut(duration: 0.15)) {
            isShowing = false
            currentBubble = nil
        }
    }
    
    /// キャラクター選択（直前と同じキャラを避ける）
    private func selectCharacter() -> CharacterID {
        var availableCharacters = CharacterID.allCases
        
        // 直前のキャラクターを除外（5人いるので必ず他の選択肢がある）
        if let last = lastCharacterID {
            availableCharacters.removeAll { $0 == last }
        }
        
        return availableCharacters.randomElement() ?? CharacterID.allCases.randomElement()!
    }
    
    /// 台詞選択（直前と同じ台詞を避ける）
    private func selectLine(
        for character: CharacterID, 
        from data: DialogueData
    ) -> DialogueLine {
        var availableLines = data.lines(for: character)
        
        // 直前の台詞を除外（在庫が1本しかない場合は許容）
        if let lastID = lastLineID, availableLines.count > 1 {
            availableLines.removeAll { $0.id == lastID }
        }
        
        return availableLines.randomElement() ?? DialogueLine(id: "fallback", text: "...")
    }
}
