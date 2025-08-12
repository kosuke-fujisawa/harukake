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

/// 保存完了ポップアップ表示判定のコンテキスト
struct SavePopupContext {
    let record: RecordItem
    let comment: Comment
    let reaction: MiniReaction
    // 将来: userSettings, cooldownSec, threshold など
}

/// 保存完了ポップアップを表示するかどうかのUIポリシー
struct SaveCompletionPolicy {
    
    /// 保存完了ポップアップの表示可否を判定（純粋関数）
    /// - Parameter context: 判定に必要なコンテキスト
    /// - Returns: ポップアップを表示するかどうか
    func shouldShowPopup(_ context: SavePopupContext) -> Bool {
        // 現在は常に表示（将来的に条件分岐を追加予定）
        // 例：金額しきい値、カテゴリ別条件、クールダウン時間、日時条件等
        return true
    }
    
    /// 保存完了ポップアップの表示可否を判定（旧API、互換性のため残す）
    /// - Parameters:
    ///   - record: 保存された記録
    ///   - comment: 生成されたコメント
    ///   - reaction: 生成されたミニリアクション
    /// - Returns: ポップアップを表示するかどうか
    func shouldShowPopup(for record: RecordItem, comment: Comment, reaction: MiniReaction) -> Bool {
        let context = SavePopupContext(record: record, comment: comment, reaction: reaction)
        return shouldShowPopup(context)
    }
    
    /// 将来的な条件例（未実装）
    /// - 最低表示金額（例：500円以上）
    /// - 特定カテゴリのみ表示
    /// - 前回表示からのクールダウン時間
    /// - 平日/休日による表示制御
    /// - ユーザー設定による表示ON/OFF
}
