//
//  AppStateObservable.swift
//  harukake
//
//  Infrastructure層 - ObservableObjectラッパー
//  SwiftUIとの統合のためのUI状態管理
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// SwiftUIとの統合のためのObservableObjectラッパー（Infrastructure層）
class AppStateObservable: ObservableObject {
    @Published var records: [RecordItem] = [] {
        didSet {
            if records.count > oldValue.count {
                DebugLogger.logDataAction("Records updated - Total count: \(records.count)")
            }
        }
    }
    @Published var currentComment: Comment?

    private let recordUseCase: RecordUseCase
    private let commentUseCase: CommentGenerationUseCase
    private let repository: RecordRepositoryProtocol

    init() {
        self.repository = InMemoryRecordRepository()
        self.recordUseCase = RecordUseCase(repository: repository)
        self.commentUseCase = CommentGenerationUseCase()

        DebugLogger.logDataAction("AppStateObservable initialized")
        loadRecords()
    }

    /// 記録を追加し、コメントを生成
    func addRecord(date: Date, category: Category, amount: Int, memo: String) {
        guard let record = recordUseCase.addRecord(date: date, category: category, amount: amount, memo: memo) else {
            return
        }

        loadRecords()
        generateComment(for: record)
    }

    /// 全記録を再読み込み
    private func loadRecords() {
        records = recordUseCase.getAllRecords()
    }

    /// コメントを生成
    private func generateComment(for record: RecordItem) {
        currentComment = commentUseCase.generateComment(for: record)
    }

    /// コメントをクリア
    func clearComment() {
        currentComment = nil
    }

    /// 月次合計金額を計算
    func calculateMonthlyTotal(for month: Date) -> Int {
        return recordUseCase.calculateMonthlyTotal(for: month)
    }

    /// カテゴリ別合計金額を計算
    func calculateCategoryTotals(for month: Date) -> [Category: Int] {
        return recordUseCase.calculateCategoryTotals(for: month)
    }
}
