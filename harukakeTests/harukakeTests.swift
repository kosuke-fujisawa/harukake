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
        
        let record = useCase.addRecord(
            date: Date(),
            category: Category.shokuhi,
            amount: 1000,
            memo: "テスト記録"
        )
        
        #expect(record != nil)
        #expect(record?.amount == 1000)
        #expect(record?.category == Category.shokuhi)
    }
    
    /// RecordUseCaseのバリデーション：0円での記録拒否
    @Test func testAddRecordRejectsZeroAmount() async throws {
        let repository = InMemoryRecordRepository()
        let useCase = RecordUseCase(repository: repository)
        
        let record = useCase.addRecord(
            date: Date(),
            category: Category.shokuhi,
            amount: 0,
            memo: "無効な記録"
        )
        
        #expect(record == nil)
    }
    
    /// RecordUseCaseのバリデーション：負数での記録拒否
    @Test func testAddRecordRejectsNegativeAmount() async throws {
        let repository = InMemoryRecordRepository()
        let useCase = RecordUseCase(repository: repository)
        
        let record = useCase.addRecord(
            date: Date(),
            category: Category.shokuhi,
            amount: -500,
            memo: "無効な記録"
        )
        
        #expect(record == nil)
    }
    
    /// 月次合計計算：同一月内の合計
    @Test func testMonthlyTotalSameMonth() async throws {
        let repository = InMemoryRecordRepository()
        let useCase = RecordUseCase(repository: repository)
        
        let calendar = Calendar.current
        let testDate = Date()
        let sameMonthDate = calendar.date(byAdding: .day, value: 5, to: testDate)!
        
        useCase.addRecord(date: testDate, category: Category.shokuhi, amount: 1000, memo: "記録1")
        useCase.addRecord(date: sameMonthDate, category: Category.koutuu, amount: 500, memo: "記録2")
        
        let total = useCase.calculateMonthlyTotal(for: testDate)
        #expect(total == 1500)
    }
    
    /// 月次合計計算：異なる月の除外
    @Test func testMonthlyTotalExcludesOtherMonths() async throws {
        let repository = InMemoryRecordRepository()
        let useCase = RecordUseCase(repository: repository)
        
        let calendar = Calendar.current
        let thisMonth = Date()
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: thisMonth)!
        
        useCase.addRecord(date: thisMonth, category: Category.shokuhi, amount: 1000, memo: "今月")
        useCase.addRecord(date: nextMonth, category: Category.shokuhi, amount: 2000, memo: "来月")
        
        let thisMonthTotal = useCase.calculateMonthlyTotal(for: thisMonth)
        #expect(thisMonthTotal == 1000)
    }
    
    /// カテゴリ別合計計算：正確な集計
    @Test func testCategoryTotalsSumsCorrectly() async throws {
        let repository = InMemoryRecordRepository()
        let useCase = RecordUseCase(repository: repository)
        
        let testDate = Date()
        
        useCase.addRecord(date: testDate, category: Category.shokuhi, amount: 1000, memo: "食費1")
        useCase.addRecord(date: testDate, category: Category.shokuhi, amount: 500, memo: "食費2")
        useCase.addRecord(date: testDate, category: Category.koutuu, amount: 300, memo: "交通費")
        
        let categoryTotals = useCase.calculateCategoryTotals(for: testDate)
        
        #expect(categoryTotals[Category.shokuhi] == 1500)
        #expect(categoryTotals[Category.koutuu] == 300)
        #expect(categoryTotals[Category.gouraku] == nil)
    }
}
