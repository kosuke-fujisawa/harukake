import Foundation

struct MissionState: Codable {
    struct Daily: Codable {
        var login: Bool = false
        var input: Bool = false
        var lastReset: Date
        
        init(lastReset: Date = Date()) {
            self.lastReset = lastReset
        }
    }
    
    struct Weekly: Codable {
        var inputsThisWeek: Int = 0
        var weekStart: Date
        
        init(weekStart: Date = Calendar.current.startOfWeek(for: Date())) {
            self.weekStart = weekStart
        }
    }
    
    var daily: Daily
    var weekly: Weekly
    
    init() {
        self.daily = Daily()
        self.weekly = Weekly()
    }
    
    init(daily: Daily, weekly: Weekly) {
        self.daily = daily
        self.weekly = weekly
    }
}

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components) ?? date
    }
}