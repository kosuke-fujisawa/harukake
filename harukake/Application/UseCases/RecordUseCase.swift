//
//  RecordUseCase.swift
//  harukake
//
//  Application層 - UseCase
//  記録に関するユースケースを実装
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// 記録に関するユースケース（ビジネス流れの調整）
class RecordUseCase {
    /// 月フォーマット用のスレッドセーフDateFormatter（ローカル生成）
    private func createMonthFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }
    private let repository: RecordRepositoryProtocol

    init(repository: RecordRepositoryProtocol) {
        self.repository = repository
    }

    /// 記録を追加するユースケース
    func addRecord(date: Date, category: Category, amount: Int, memo: String) -> Result<RecordItem, RecordError> {
        let record = RecordItem(date: date, category: category, amount: amount, memo: memo)

        guard record.isValidAmount else {
            let error = RecordError.invalidAmount(amount)
            DebugLogger.logError("Failed to add record: \(error.localizedDescription)")
            return .failure(error)
        }

        repository.addRecord(record)
        DebugLogger.logBusinessAction(
            "Record added successfully - Category: \(category.displayName), Amount: ¥\(amount)"
        )

        return .success(record)
    }

    /// 全記録を取得するユースケース
    func getAllRecords() -> [RecordItem] {
        return repository.getAllRecords()
    }

    /// 月次合計金額を計算するビジネスロジック
    func calculateMonthlyTotal(for month: Date) -> Int {
        DebugLogger.logBusinessAction("Calculating monthly total for: \(createMonthFormatter().string(from: month))")

        let records = repository.getRecordsForMonth(month)
        let total = records.reduce(0) { $0 + $1.amount }

        DebugLogger.logBusinessAction("Monthly total calculated: ¥\(total) (\(records.count) records)")
        return total
    }

    /// カテゴリ別合計金額を計算するビジネスロジック
    func calculateCategoryTotals(for month: Date) -> [Category: Int] {
        DebugLogger.logBusinessAction("Calculating category totals for: \(createMonthFormatter().string(from: month))")

        let records = repository.getRecordsForMonth(month)

        var totals: [Category: Int] = [:]
        for record in records {
            totals[record.category, default: 0] += record.amount
        }

        DebugLogger.logBusinessAction("Category totals calculated - \(totals.count) categories with data")
        return totals
    }
}
