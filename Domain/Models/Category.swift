import Foundation

enum Category: String, Codable, CaseIterable {
    case 食費 = "食費"
    case 日用品 = "日用品"
    case 交通 = "交通"
    case 娯楽 = "娯楽"
    case 通信 = "通信"
    case 光熱 = "光熱"
    case 家賃 = "家賃"
    case その他 = "その他"
    
    var displayName: String {
        return rawValue
    }
}