import Foundation

struct BoardGame: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let yearPublished: Int?
    
    static func == (lhs: BoardGame, rhs: BoardGame) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
} 