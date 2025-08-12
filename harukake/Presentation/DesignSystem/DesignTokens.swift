//
//  DesignTokens.swift
//  harukake
//
//  Presentation層 - DesignSystem
//  デザイントークンの集約管理
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// カテゴリ色パレットの管理
enum CategoryColorPalette {
    /// カテゴリに対応する色を取得
    /// - Parameter category: カテゴリ
    /// - Returns: 対応する色
    static func color(for category: Category) -> Color {
        switch category {
        case .shokuhi:
            return .blue
        case .yatin:
            return .orange
        case .koutuu:
            return .green
        case .gouraku:
            return .purple
        case .tuusin:
            return .red
        case .kounetu:
            return .mint
        case .nichiyouhin:
            return .pink
        case .sonota:
            return .gray
        }
    }
}
