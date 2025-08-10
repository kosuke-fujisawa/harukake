//
//  RecordError.swift
//  harukake
//
//  Domain層 - Error
//  記録に関するエラーを定義
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// 記録に関するドメインエラー
enum RecordError: LocalizedError {
    case invalidAmount(Int)
    case repositoryError(String)
    case validationError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidAmount(let amount):
            return "無効な金額: \(amount)円。1円以上を入力してください。"
        case .repositoryError(let message):
            return "データ保存エラー: \(message)"
        case .validationError(let message):
            return "入力値エラー: \(message)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidAmount:
            return "1円以上の正の整数を入力してください。例：1000、500"
        case .repositoryError:
            return "しばらく待ってから再度お試しください。"
        case .validationError:
            return "入力内容を確認して、再度お試しください。"
        }
    }
}
