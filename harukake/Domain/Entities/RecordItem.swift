//
//  RecordItem.swift
//  harukake
//
//  Domain層 - Entity
//  家計簿記録項目のドメインエンティティ
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// 家計簿記録項目を表すドメインエンティティ（純粋なビジネスルール）
struct RecordItem: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let category: Category
    let amount: Int
    let memo: String

    init(date: Date, category: Category, amount: Int, memo: String = "") {
        self.date = date
        self.category = category
        self.amount = amount
        self.memo = memo
    }

    /// ビジネスルール: 有効な金額かどうかを判定
    var isValidAmount: Bool {
        return amount > 0
    }
}
