import Foundation

struct OfficialRoute: Identifiable, Equatable, Sendable {
    enum ID: String, CaseIterable, Hashable, Sendable {
        case frances
        case norte
        case primitivo
        case ingles
        case portugues
        case portuguesCoastal
        case viaDeLaPlata
        case invierno
        case fisterraMuxia
        case arousaUlla
    }

    let id: ID
    let name: String
    let origin: String
    let shortDescription: String
    let terrain: String
    let officialContext: String
}
