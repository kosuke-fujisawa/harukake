import Foundation

class ProgressCalculator {
    
    static func calculateRequiredXP(level: Int) -> Int {
        guard level >= 1 else { return 50 }
        return 50 + (level - 1) * 10
    }
    
    static func calculateLevel(exp: Int) -> Int {
        guard exp >= 0 else { return 1 }
        
        var currentLevel = 1
        var totalXPRequired = 0
        
        while currentLevel < 100 {
            let xpForNextLevel = calculateRequiredXP(level: currentLevel)
            if totalXPRequired + xpForNextLevel > exp {
                break
            }
            totalXPRequired += xpForNextLevel
            currentLevel += 1
        }
        
        return currentLevel
    }
}