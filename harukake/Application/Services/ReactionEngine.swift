//
//  ReactionEngine.swift
//  harukake
//
//  Application層 - Service
//  キャラクター反応生成エンジン
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// キャラクター反応生成エンジン
final class ReactionEngine {
    /// 前回生成したキャラクターID（重複回避用）
    private var lastCharacterID: CharacterID?
    
    /// 記録保存時のミニリアクションを生成
    func getMiniReaction(for record: RecordItem) -> MiniReaction {
        DebugLogger.logBusinessAction(
            "Generating mini reaction for category: \(record.category.displayName), amount: ¥\(record.amount)"
        )
        
        // 重複回避ロジック
        let availableCharacters = CharacterID.allCases.filter { $0 != lastCharacterID }
        let selectedCharacter = availableCharacters.randomElement() ?? .hikari
        lastCharacterID = selectedCharacter
        
        // カテゴリ・金額に応じたコメント生成
        let commentText = generateMiniComment(for: record.category, amount: record.amount)
        
        let reaction = MiniReaction(characterID: selectedCharacter, text: commentText)
        
        DebugLogger.logBusinessAction(
            "Mini reaction generated - Character: \(selectedCharacter.displayName), Text: \(commentText)"
        )
        
        return reaction
    }
    
    /// ミニコメント生成（短縮版）
    private func generateMiniComment(for category: Category, amount: Int) -> String {
        switch category {
        case .shokuhi:
            return amount > 2000 ? "外食かな？" : "節約上手だね！"
        case .yatin:
            return "固定費お疲れさま"
        case .kounetu:
            return "電気代チェック！"
        case .gouraku:
            return "リフレッシュも大事"
        default:
            return "記録お疲れさま"
        }
    }
}
