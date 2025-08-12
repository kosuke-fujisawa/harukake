//
//  CurrencyFormatter.swift
//  harukake
//
//  Infrastructure層 - Utility
//  通貨フォーマッタ - 金額の表示フォーマット処理
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// 通貨フォーマッタ（再利用のためstatic）
struct CurrencyFormatter {
    /// 日本円フォーマッタ（桁区切り・通貨記号付き）
    private static let jpyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "JPY"
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    /// 金額を日本円フォーマットで表示（例: ¥1,234）
    /// - Parameter amount: 金額（円）
    /// - Returns: フォーマット済み文字列
    static func formatJPY(_ amount: Int) -> String {
        return jpyFormatter.string(from: NSNumber(value: amount)) ?? "¥0"
    }
    
    /// 金額を桁区切りのみで表示（例: 1,234円）
    /// - Parameter amount: 金額（円）
    /// - Returns: フォーマット済み文字列
    static func formatWithSeparator(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ja_JP")
        return (formatter.string(from: NSNumber(value: amount)) ?? "0") + "円"
    }
}
