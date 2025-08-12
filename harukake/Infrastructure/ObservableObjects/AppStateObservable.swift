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

import Foundation
import Combine

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
    }
    
    /// 初期ロード（onAppear等で明示的に呼び出す）
    func loadInitialData() {
        loadRecords()
    }

    /// 記録を追加（Action）
    func addRecord(date: Date, category: Category, amount: Int, memo: String) -> Result<RecordItem, RecordError> {
        let result = recordUseCase.addRecord(date: date, category: category, amount: amount, memo: memo)
        
        switch result {
        case .success(let record):
            loadRecords()
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

    /// コメントを生成（Action）
    func generateComment(for record: RecordItem) -> Comment {
        return commentUseCase.generateComment(for: record)
    }

    /// ミニリアクションを生成（Action）
    func generateMiniReaction(for record: RecordItem) -> MiniReaction {
        return reactionEngine.getMiniReaction(for: record)
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
