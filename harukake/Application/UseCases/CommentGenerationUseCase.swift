//
//  CommentGenerationUseCase.swift
//  harukake
//
//  Application層 - UseCase
//  コメント生成に関するユースケースを実装
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// コメント生成に関するユースケース
final class CommentGenerationUseCase {

    /// 記録に基づいてコメントを生成するユースケース
    func generateComment(for record: RecordItem) -> Comment {
        DebugLogger.logBusinessAction(
            "Generating comment for category: \(record.category.displayName), amount: ¥\(record.amount)"
        )

        let characters = CharacterID.allCases
        let randomCharacter = characters.randomElement() ?? .hikari

        let comments = generateCommentMessages(for: record.category, amount: record.amount)
        let randomMessage = comments.randomElement() ?? "記録お疲れ様！"

        let comment = Comment(character: randomCharacter, message: randomMessage)
        DebugLogger.logBusinessAction(
            "Comment generated - Character: \(randomCharacter.displayName), Message: \(randomMessage)"
        )

        return comment
    }

    /// カテゴリと金額に基づいてコメント候補を生成
    private func generateCommentMessages(for category: Category, amount: Int) -> [String] {
        switch category {
        case .shokuhi:
            if amount > 2000 {
                return ["外食かな？楽しそう！", "たまの贅沢もいいよね", "美味しそう！何食べたの？"]
            } else {
                return ["節約上手だね", "自炊偉い！", "健康的でいいね"]
            }
        case .yatin:
            return ["固定費はしっかり管理してるね", "家賃は大きな出費だよね", "住環境は大切"]
        case .kounetu:
            return ["電気代どうだった？", "節電意識してる？", "季節で変わるよね"]
        case .gouraku:
            return ["リフレッシュも大事！", "何して遊んだの？", "楽しい時間だった？"]
        default:
            return ["記録お疲れ様！", "継続が大事だね", "順調だね"]
        }
    }
}
