//
//  SaveCompletionPolicy.swift
//  harukake
//
//  Presentation層 - UIポリシー
//  保存完了ポップアップ表示可否の判定ロジック
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// 保存完了ポップアップを表示するかどうかのUIポリシー
struct SaveCompletionPolicy {
    
    /// 保存完了ポップアップの表示可否を判定
    /// - Parameters:
    ///   - record: 保存された記録
    ///   - comment: 生成されたコメント
    ///   - reaction: 生成されたミニリアクション
    /// - Returns: ポップアップを表示するかどうか
    func shouldShowPopup(for record: RecordItem, comment: Comment, reaction: MiniReaction) -> Bool {
        // 現在は常に表示（将来的に条件分岐を追加予定）
        // 例：金額しきい値、カテゴリ別条件、クールダウン時間、日時条件等
        
        DebugLogger.logUIAction(
            "SaveCompletionPolicy evaluated - Record: \(record.category.displayName) ¥\(record.amount), Result: true"
        )
        
        return true
    }
    
    /// 将来的な条件例（未実装）
    /// - 最低表示金額（例：500円以上）
    /// - 特定カテゴリのみ表示
    /// - 前回表示からのクールダウン時間
    /// - 平日/休日による表示制御
    /// - ユーザー設定による表示ON/OFF
}
