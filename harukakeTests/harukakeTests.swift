//
//  harukakeTests.swift
//  harukakeTests
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Testing
import Foundation
@testable import harukake

struct HarukakeTests {
    /// RecordUseCaseのバリデーション：正常なレコード追加
    @Test func testAddRecordValidAmount() async throws {
        let repository = InMemoryRecordRepository()
        let useCase = RecordUseCase(repository: repository)
        
        let testDate = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 15))!
        
        let result = useCase.addRecord(
            date: testDate,
            category: Category.shokuhi,
            amount: 1000,
            memo: "テスト記録"
        )
        
        switch result {
        case .success(let record):
            #expect(record.amount == 1000)
            #expect(record.category == Category.shokuhi)
        case .failure:
            #expect(Bool(false), "Expected success but got failure")
        }
    }
    
    /// RecordUseCaseのバリデーション：0円での記録拒否
    @Test func testAddRecordRejectsZeroAmount() async throws {
        let repository = InMemoryRecordRepository()
        let useCase = RecordUseCase(repository: repository)
        
        let testDate = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 15))!
        
        let result = useCase.addRecord(
            date: testDate,
            category: Category.shokuhi,
            amount: 0,
            memo: "無効な記録"
        )
        
        switch result {
        case .success:
            #expect(Bool(false), "Expected failure but got success")
        case .failure:
            break // Expected
        }
    }
    
    /// RecordUseCaseのバリデーション：負数での記録拒否
    @Test func testAddRecordRejectsNegativeAmount() async throws {
        let repository = InMemoryRecordRepository()
        let useCase = RecordUseCase(repository: repository)
        
        let testDate = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 15))!
        
        let result = useCase.addRecord(
            date: testDate,
            category: Category.shokuhi,
            amount: -500,
            memo: "無効な記録"
        )
        
        switch result {
        case .success:
            #expect(Bool(false), "Expected failure but got success")
        case .failure:
            break // Expected
        }
    }
    
    /// 月次合計計算：同一月内の合計
    @Test func testMonthlyTotalSameMonth() async throws {
        let repository = InMemoryRecordRepository()
        let useCase = RecordUseCase(repository: repository)
        
        // 固定日付を使用して安定性を確保
        let calendar = Calendar.current
        let testDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 15))!
        let sameMonthDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 20))!
        
        let result1 = useCase.addRecord(date: testDate, category: Category.shokuhi, amount: 1000, memo: "記録1")
        let result2 = useCase.addRecord(date: sameMonthDate, category: Category.koutuu, amount: 500, memo: "記録2")
        
        switch (result1, result2) {
        case (.success, .success):
            break // Expected
        default:
            #expect(Bool(false), "Expected both results to be success")
        }
        
        let total = useCase.calculateMonthlyTotal(for: testDate)
        #expect(total == 1500)
    }
    
    /// 月次合計計算：異なる月の除外
    @Test func testMonthlyTotalExcludesOtherMonths() async throws {
        let repository = InMemoryRecordRepository()
        let useCase = RecordUseCase(repository: repository)
        
        // 固定日付を使用して安定性を確保
        let calendar = Calendar.current
        let thisMonth = calendar.date(from: DateComponents(year: 2024, month: 1, day: 15))!
        let nextMonth = calendar.date(from: DateComponents(year: 2024, month: 2, day: 15))!
        
        let result1 = useCase.addRecord(date: thisMonth, category: Category.shokuhi, amount: 1000, memo: "今月")
        let result2 = useCase.addRecord(date: nextMonth, category: Category.shokuhi, amount: 2000, memo: "来月")
        
        switch (result1, result2) {
        case (.success, .success):
            break // Expected
        default:
            #expect(Bool(false), "Expected both results to be success")
        }
        
        let thisMonthTotal = useCase.calculateMonthlyTotal(for: thisMonth)
        #expect(thisMonthTotal == 1000)
    }
    
    /// カテゴリ別合計計算：正確な集計
    @Test func testCategoryTotalsSumsCorrectly() async throws {
        let repository = InMemoryRecordRepository()
        let useCase = RecordUseCase(repository: repository)
        
        // 固定日付を使用して安定性を確保
        let testDate = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 15))!
        
        let result1 = useCase.addRecord(date: testDate, category: Category.shokuhi, amount: 1000, memo: "食費1")
        let result2 = useCase.addRecord(date: testDate, category: Category.shokuhi, amount: 500, memo: "食費2")
        let result3 = useCase.addRecord(date: testDate, category: Category.koutuu, amount: 300, memo: "交通費")
        
        switch (result1, result2, result3) {
        case (.success, .success, .success):
            break // Expected
        default:
            #expect(Bool(false), "Expected all results to be success")
        }
        
        let categoryTotals = useCase.calculateCategoryTotals(for: testDate)
        
        #expect(categoryTotals[Category.shokuhi] == 1500)
        #expect(categoryTotals[Category.koutuu] == 300)
        #expect(categoryTotals[Category.gouraku] == nil)
    }
    
    /// SaveCompletionPolicyのテスト：デフォルトでtrue
    @Test func testSaveCompletionPolicy_shouldShowPopup_returnsTrue() async throws {
        let policy = SaveCompletionPolicy()
        let record = RecordItem(date: Date(), category: Category.shokuhi, amount: 1000, memo: "テスト")
        let comment = Comment(character: CharacterID.hikari, message: "テストコメント")
        let reaction = MiniReaction(characterID: CharacterID.hikari, text: "テストリアクション")
        
        #expect(policy.shouldShowPopup(for: record, comment: comment, reaction: reaction) == true)
    }
}
