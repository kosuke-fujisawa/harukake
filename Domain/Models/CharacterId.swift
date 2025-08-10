import Foundation

enum CharacterId: String, Codable, CaseIterable {
    case hikari = "hikari"
    case reina = "reina" 
    case mayu = "mayu"
    case makoto = "makoto"
    case daichi = "daichi"
    
    var displayName: String {
        switch self {
        case .hikari: return "守銭寺ひかり"
        case .reina: return "華野れいな"
        case .mayu: return "本城まゆ"
        case .makoto: return "佐久間誠"
        case .daichi: return "中原大地"
        }
    }
}