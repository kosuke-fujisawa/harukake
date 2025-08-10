//
//  DebugLogger.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation
import os.log

/// デバッグビルド専用のログユーティリティ
struct DebugLogger {
    private static let uiLogger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "harukake", category: "UI")
    private static let dataLogger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "harukake", category: "Data")
    private static let businessLogger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "harukake",
        category: "Business"
    )
    private static let errorLogger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "harukake", category: "Error")

    /// UI関連のアクション（画面遷移、シート開閉）をログ出力
    static func logUIAction(_ message: String) {
        #if DEBUG
        uiLogger.info("[UI] \(message)")
        #endif
    }

    /// データ関連のアクション（保存、取得）をログ出力
    static func logDataAction(_ message: String) {
        #if DEBUG
        dataLogger.info("[Data] \(message)")
        #endif
    }

    /// ビジネスロジック実行をログ出力
    static func logBusinessAction(_ message: String) {
        #if DEBUG
        businessLogger.info("[Business] \(message)")
        #endif
    }

    /// エラー発生時の詳細情報をログ出力
    static func logError(_ message: String, error: Error? = nil) {
        #if DEBUG
        if let error = error {
            errorLogger.error("[Error] \(message) - \(error.localizedDescription)")
        } else {
            errorLogger.error("[Error] \(message)")
        }
        #endif
    }

    /// 汎用ログ出力
    static func log(_ message: String) {
        #if DEBUG
        uiLogger.info("\(message)")
        #endif
    }
}
