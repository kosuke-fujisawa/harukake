import Foundation

struct FixedCostRule: Codable {
    var category: Category
    var dayOfMonth: Int
    var amount: Int
    
    init(category: Category, dayOfMonth: Int, amount: Int) {
        self.category = category
        self.dayOfMonth = dayOfMonth
        self.amount = amount
    }
}

enum FixedCostDiff {
    case increase(Int)
    case decrease(Int) 
    case same
    case noHistory
}