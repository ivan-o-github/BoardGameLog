import Foundation

actor BoardGameService {
    static let shared = BoardGameService()
    private var searchCache: [String: [BoardGame]] = [:]
    private let cacheTimeout: TimeInterval = 3600 // 1 hour
    private var lastSearchTimes: [String: Date] = [:]
    
    private init() {}
    
    func searchGames(query: String) async throws -> [BoardGame] {
        // Check cache first
        if let cachedResults = searchCache[query],
           let lastSearchTime = lastSearchTimes[query],
           Date().timeIntervalSince(lastSearchTime) < cacheTimeout {
            return cachedResults
        }
        
        // Construct URL
        guard var urlComponents = URLComponents(string: "https://boardgamegeek.com/xmlapi2/search") else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "type", value: "boardgame")
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        // Fetch data
        let (data, _) = try await URLSession.shared.data(from: url)
        let games = try parseXMLResponse(data)
        
        // Cache results
        searchCache[query] = games
        lastSearchTimes[query] = Date()
        
        return games
    }
    
    private func parseXMLResponse(_ data: Data) throws -> [BoardGame] {
        guard let xmlString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "XMLParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to convert data to string"])
        }
        
        var games: [BoardGame] = []
        
        // Basic XML parsing using string manipulation (for simplicity)
        // In a production app, you should use proper XML parsing
        let items = xmlString.components(separatedBy: "<item type=\"boardgame\"")
        
        for item in items.dropFirst() { // First element is before any item
            if let idRange = item.range(of: "id=\""),
               let idEndRange = item.range(of: "\"", range: idRange.upperBound..<item.endIndex),
               let nameRange = item.range(of: "<name type=\"primary\" value=\""),
               let nameEndRange = item.range(of: "\"", range: nameRange.upperBound..<item.endIndex) {
                
                let id = Int(item[idRange.upperBound..<idEndRange.lowerBound]) ?? 0
                let name = String(item[nameRange.upperBound..<nameEndRange.lowerBound])
                
                var yearPublished: Int? = nil
                if let yearRange = item.range(of: "<yearpublished value=\""),
                   let yearEndRange = item.range(of: "\"", range: yearRange.upperBound..<item.endIndex) {
                    yearPublished = Int(item[yearRange.upperBound..<yearEndRange.lowerBound])
                }
                
                let game = BoardGame(id: id, name: name, yearPublished: yearPublished)
                games.append(game)
            }
        }
        
        return games
    }
} 