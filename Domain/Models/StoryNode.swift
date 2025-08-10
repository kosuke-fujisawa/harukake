import Foundation

struct StoryNode: Identifiable, Codable {
    enum Kind: String, Codable {
        case main = "main"
        case side = "side"
    }
    
    enum Unlock: Codable {
        case level(Int)
        case jewel(Int)
        
        enum CodingKeys: String, CodingKey {
            case type, value
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            let value = try container.decode(Int.self, forKey: .value)
            
            switch type {
            case "level":
                self = .level(value)
            case "jewel":
                self = .jewel(value)
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown unlock type")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .level(let value):
                try container.encode("level", forKey: .type)
                try container.encode(value, forKey: .value)
            case .jewel(let value):
                try container.encode("jewel", forKey: .type)
                try container.encode(value, forKey: .value)
            }
        }
    }
    
    var id: String
    var title: String
    var paragraphs: [String]
    var kind: Kind
    var unlock: Unlock
    var character: CharacterId?
    
    init(id: String, title: String, paragraphs: [String], kind: Kind, unlock: Unlock, character: CharacterId? = nil) {
        self.id = id
        self.title = title
        self.paragraphs = paragraphs
        self.kind = kind
        self.unlock = unlock
        self.character = character
    }
}