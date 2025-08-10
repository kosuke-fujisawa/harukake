import Foundation

struct RecordItem: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var category: Category
    var amount: Int
    var memo: String?
    var isFixed: Bool = false
    
    init(date: Date, category: Category, amount: Int, memo: String? = nil, isFixed: Bool = false) {
        self.date = date
        self.category = category
        self.amount = amount
        self.memo = memo
        self.isFixed = isFixed
    }
}