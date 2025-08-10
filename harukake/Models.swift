//
//  Models.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

enum Category: String, CaseIterable {
    case 食費 = "食費"
    case 日用品 = "日用品"
    case 交通 = "交通"
    case 娯楽 = "娯楽"
    case 通信 = "通信"
    case 光熱 = "光熱"
    case 家賃 = "家賃"
    case その他 = "その他"
}

struct RecordItem: Identifiable {
    let id = UUID()
    var date: Date
    var category: Category
    var amount: Int
    var memo: String

    init(date: Date, category: Category, amount: Int, memo: String = "") {
        self.date = date
        self.category = category
        self.amount = amount
        self.memo = memo
    }
}

enum CharacterID: String, CaseIterable {
    case hikari = "ひかり"
    case reina = "れいな"
    case mayu = "まゆ"
    case makoto = "誠"
    case daichi = "大地"
}

struct Comment {
    let character: CharacterID
    let message: String
}

class AppData: ObservableObject {
    @Published var records: [RecordItem] = [] {
        didSet {
            if records.count > oldValue.count {
                DebugLogger.logDataAction("Records updated - Total count: \(records.count)")
            }
        }
    }
    @Published var currentComment: Comment?

    init() {
        DebugLogger.logDataAction("AppData initialized")
    }

    func addRecord(_ record: RecordItem) {
        records.append(record)
        DebugLogger.logDataAction("Record saved - Category: \(record.category.rawValue), Amount: ¥\(record.amount)")
        generateComment(for: record)
    }

    private func generateComment(for record: RecordItem) {
        DebugLogger.logBusinessAction("Generating comment for category: \(record.category.rawValue), amount: ¥\(record.amount)")
        
        let characters = CharacterID.allCases
        let randomCharacter = characters.randomElement() ?? .hikari

        let comments = generateCommentMessages(for: record.category, amount: record.amount)
        let randomMessage = comments.randomElement() ?? "記録お疲れ様！"

        currentComment = Comment(character: randomCharacter, message: randomMessage)
        DebugLogger.logBusinessAction("Comment generated - Character: \(randomCharacter.rawValue), Message: \(randomMessage)")
    }

    private func generateCommentMessages(for category: Category, amount: Int) -> [String] {
        switch category {
        case .食費:
            if amount > 2000 {
                return ["外食かな？楽しそう！", "たまの贅沢もいいよね", "美味しそう！何食べたの？"]
            } else {
                return ["節約上手だね", "自炊偉い！", "健康的でいいね"]
            }
        case .家賃:
            return ["固定費はしっかり管理してるね", "家賃は大きな出費だよね", "住環境は大切"]
        case .光熱:
            return ["電気代どうだった？", "節電意識してる？", "季節で変わるよね"]
        case .娯楽:
            return ["リフレッシュも大事！", "何して遊んだの？", "楽しい時間だった？"]
        default:
            return ["記録お疲れ様！", "継続が大事だね", "順調だね"]
        }
    }

    func clearComment() {
        currentComment = nil
    }
    
    /// 月次合計金額を計算するビジネスロジック
    func calculateMonthlyTotal(for month: Date) -> Int {
        DebugLogger.logBusinessAction("Calculating monthly total for: \(DateFormatter().string(from: month))")
        
        let calendar = Calendar.current
        let filtered = records.filter { record in
            calendar.isDate(record.date, equalTo: month, toGranularity: .month)
        }
        
        let total = filtered.reduce(0) { $0 + $1.amount }
        DebugLogger.logBusinessAction("Monthly total calculated: ¥\(total) (\(filtered.count) records)")
        
        return total
    }
    
    /// カテゴリ別合計金額を計算するビジネスロジック
    func calculateCategoryTotals(for month: Date) -> [Category: Int] {
        DebugLogger.logBusinessAction("Calculating category totals for: \(DateFormatter().string(from: month))")
        
        let calendar = Calendar.current
        let filtered = records.filter { record in
            calendar.isDate(record.date, equalTo: month, toGranularity: .month)
        }
        
        var totals: [Category: Int] = [:]
        for record in filtered {
            totals[record.category, default: 0] += record.amount
        }
        
        DebugLogger.logBusinessAction("Category totals calculated - \(totals.count) categories with data")
        return totals
    }
}
