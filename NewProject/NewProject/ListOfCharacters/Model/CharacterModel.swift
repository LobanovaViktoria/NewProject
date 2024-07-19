import SwiftUI

// MARK: - struct CharactersResponse

struct CharactersResponse: Codable {
    let info: Info
    let results: [CharacterModel]
    
    enum CodingKeys: String, CodingKey {
    case info, results
    }
}

// MARK: - struct Info

struct Info: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
    
    enum CodingKeys: String, CodingKey {
        case count, pages, next, prev
    }
}

// MARK: - struct CharacterModel

struct CharacterModel: Identifiable, Codable, Equatable {
    let id: Int
    let name: String?
    let status: Status?
    let species: String?
    let type: String?
    let gender: String?
    let origin, location: Location
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case image
        case episode
        case url
        case created
    }
}

// MARK: - struct Episode

struct Episode: Identifiable, Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

// MARK: - struct Location

struct Location: Codable, Equatable {
    let name: String?
    let url: String?
}

// MARK: - enums

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "Unknown"
    
    static var allCases: [Gender] {
        return [.female, .genderless, .male, .unknown]
    }
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var color: Color {
        switch self {
        case .alive:
                .greenUniversal
        case .dead:
                .redUniversal
        case .unknown:
                .grayForStatus
        }
    }
    
    static var allCases: [Status] {
        return [.alive, .dead, .unknown]
    }
}

