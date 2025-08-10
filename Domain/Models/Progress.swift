import Foundation

struct Progress: Codable {
    var level: Int = 1
    var exp: Int = 0
    var jewels: Int = 0
    var readStories: Set<String> = []
    var titles: [String] = []
    
    init() {}
    
    init(level: Int, exp: Int, jewels: Int, readStories: Set<String> = [], titles: [String] = []) {
        self.level = level
        self.exp = exp
        self.jewels = jewels
        self.readStories = readStories
        self.titles = titles
    }
}