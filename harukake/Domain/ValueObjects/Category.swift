//
//  Category.swift
//  harukake
//
//  Domain層 - ValueObject
//  カテゴリを表す値オブジェクト
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// 家計簿のカテゴリを表す値オブジェクト
enum Category: String, CaseIterable, Equatable, Hashable {
    case shokuhi = "食費"
    case nichiyouhin = "日用品"
    case koutuu = "交通"
    case gouraku = "娯楽"
    case tuusin = "通信"
    case kounetu = "光熱"
    case yatin = "家賃"
    case sonota = "その他"

    /// 表示名を取得
    var displayName: String {
        return rawValue
    }
}
