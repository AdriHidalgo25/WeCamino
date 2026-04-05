import Foundation

struct OfficialRoute: Identifiable, Equatable, Sendable {
    enum StageMode: String, Sendable {
        case walking
        case maritime
    }

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

    struct Coordinate: Hashable, Sendable {
        let latitude: Double
        let longitude: Double
    }

    struct Stop: Identifiable, Hashable, Sendable {
        let name: String
        let searchQuery: String
        let coordinate: Coordinate?

        var id: String {
            searchQuery
        }
    }

    struct Stage: Identifiable, Hashable, Sendable {
        let start: Stop
        let end: Stop
        let distanceKilometers: Double
        let mode: StageMode

        var id: String {
            "\(start.id)-\(end.id)"
        }
    }

    let id: ID
    let name: String
    let origin: String
    let shortDescription: String
    let terrain: String
    let officialContext: String
    let stages: [Stage]

    var totalDistanceKilometers: Double {
        stages.reduce(0) { partialResult, stage in
            partialResult + stage.distanceKilometers
        }
    }

    var heroStop: Stop? {
        stages.first?.start
    }

    var stops: [Stop] {
        var uniqueStops: [Stop] = []
        var seenStopIDs = Set<String>()

        for stage in stages {
            for stop in [stage.start, stage.end] {
                if seenStopIDs.insert(stop.id).inserted {
                    uniqueStops.append(stop)
                }
            }
        }

        return uniqueStops
    }
}
