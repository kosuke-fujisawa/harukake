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
import Foundation

/// SwiftUIとの統合のためのObservableObjectラッパー（Infrastructure層）
@MainActor
class AppStateObservable: ObservableObject {
    @Published var records: [RecordItem] = [] {
        didSet {
            if records.count > oldValue.count {
                DebugLogger.logDataAction("Records updated - Total count: \(records.count)")
            }
        }
    }
    @Published var currentComment: Comment?
    @Published var currentMiniReaction: MiniReaction?

    private let recordUseCase: RecordUseCase
    private let commentUseCase: CommentGenerationUseCase
    private let reactionEngine: ReactionEngine
    private let repository: RecordRepositoryProtocol

    init(repository: RecordRepositoryProtocol = InMemoryRecordRepository()) {
        self.repository = repository
        self.recordUseCase = RecordUseCase(repository: repository)
        self.commentUseCase = CommentGenerationUseCase()
        self.reactionEngine = ReactionEngine()

        DebugLogger.logDataAction("AppStateObservable initialized with repository: \(type(of: repository))")
        loadRecords()
    }

    /// 記録を追加し、コメントを生成
    func addRecord(date: Date, category: Category, amount: Int, memo: String) -> Result<RecordItem, RecordError> {
        let result = recordUseCase.addRecord(date: date, category: category, amount: amount, memo: memo)
        
        switch result {
        case .success(let record):
            loadRecords()
            generateComment(for: record)
            generateMiniReaction(for: record)
            return .success(record)
        case .failure(let error):
            DebugLogger.logError("Failed to add record in AppStateObservable: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    /// 全記録を再読み込み
    private func loadRecords() {
        records = recordUseCase.getAllRecords()
    }

    /// コメントを生成
    private func generateComment(for record: RecordItem) {
        currentComment = commentUseCase.generateComment(for: record)
    }

    /// ミニリアクションを生成
    private func generateMiniReaction(for record: RecordItem) {
        currentMiniReaction = reactionEngine.getMiniReaction(for: record)
    }

    /// コメントをクリア
    func clearComment() {
        currentComment = nil
    }

    /// ミニリアクションをクリア
    func clearMiniReaction() {
        currentMiniReaction = nil
    }

    /// 月次合計金額を計算
    func calculateMonthlyTotal(for month: Date) -> Int {
        return recordUseCase.calculateMonthlyTotal(for: month)
    }

    /// カテゴリ別合計金額を計算
    func calculateCategoryTotals(for month: Date) -> [Category: Int] {
        return recordUseCase.calculateCategoryTotals(for: month)
    }
    
    /// 当月の日別収支データ（上部グラフ用）
    var currentMonthDailyNet: [Double] {
        // モック実装：実際の収支計算ロジックに置き換える
        let calendar = Calendar.current
        let now = Date()
        guard let range = calendar.range(of: .day, in: .month, for: now) else { return [] }
        
        // 今月の日数分のダミーデータ
        return (1...range.count).map { day in
            let baseValue = Double.random(in: -8000...12000)
            // 週末は支出が多めになる傾向を模擬
            let weekday = calendar.dateInterval(of: .month, for: now)?
                .start.addingTimeInterval(TimeInterval((day-1) * 86400))
            let isWeekend = weekday.map { calendar.isDateInWeekend($0) } ?? false
            return isWeekend ? baseValue - 2000 : baseValue
        }
    }
    
    /// 月間収支サマリーテキスト（上部グラフ用）
    var monthSummaryText: String {
        // モック実装：実際の計算ロジックに置き換える
        // 現在の実装では全て支出として扱い、収入は外部から手動入力される想定
        let totalExpense = records.reduce(0) { $0 + $1.amount }
        let mockIncome = Int.random(in: 200000...400000) // モック収入データ
        let netBalance = mockIncome - totalExpense
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let incomeText = formatter.string(from: NSNumber(value: mockIncome)) ?? "0"
        let expenseText = formatter.string(from: NSNumber(value: totalExpense)) ?? "0"
        let balanceText = formatter.string(from: NSNumber(value: netBalance)) ?? "0"
        return "今月: 収入¥\(incomeText) / 支出¥\(expenseText) / 収支¥\(balanceText)"
    }
    
    /// 当月の収入（モック実装）
    var currentMonthIncome: Double {
        return Double(Int.random(in: 200000...400000))
    }
    
    /// 当月の支出（モック実装）
    var currentMonthExpense: Double {
        return Double(records.reduce(0) { $0 + $1.amount })
    }
    
    /// 現在のレベル（モック実装）
    var currentLevel: Int {
        return min(1 + records.count / 10, 99) // 10記録で1レベル、最大99
    }
}
