import Foundation

protocol OfficialRouteRepository: Sendable {
    func fetchRoutes() async -> [OfficialRoute]
    func fetchRoute(id: OfficialRoute.ID) async -> OfficialRoute?
}

struct LocalOfficialRouteRepository: OfficialRouteRepository {
    func fetchRoutes() async -> [OfficialRoute] {
        routes
    }

    func fetchRoute(id: OfficialRoute.ID) async -> OfficialRoute? {
        routes.first { $0.id == id }
    }

    // Seed data curated from official Xunta de Galicia and Pilgrim Office route references.
    private let routes: [OfficialRoute] = [
        OfficialRoute(
            id: .frances,
            name: "Camino Frances",
            origin: "Roncesvalles or Somport toward Santiago",
            shortDescription: "The iconic Camino route and the clearest entry point for many first-time pilgrims.",
            terrain: "Historic towns, strong pilgrim infrastructure and a classic progression into Galicia through O Cebreiro.",
            officialContext: "Widely recognized as the best-known Jacobean route and one of the central historic backbones of the Camino.",
            stages: [
                stage("O Cebreiro", "O Cebreiro, Lugo, Galicia, Spain", "Triacastela", "Triacastela, Lugo, Galicia, Spain", 21.8),
                stage("Triacastela", "Triacastela, Lugo, Galicia, Spain", "Sarria", "Sarria, Lugo, Galicia, Spain", 18.0),
                stage("Sarria", "Sarria, Lugo, Galicia, Spain", "Portomarin", "Portomarin, Lugo, Galicia, Spain", 22.2),
                stage("Portomarin", "Portomarin, Lugo, Galicia, Spain", "Palas de Rei", "Palas de Rei, Lugo, Galicia, Spain", 25.0),
                stage("Palas de Rei", "Palas de Rei, Lugo, Galicia, Spain", "Melide", "Melide, A Coruna, Galicia, Spain", 14.6),
                stage("Melide", "Melide, A Coruna, Galicia, Spain", "Arzua", "Arzua, A Coruna, Galicia, Spain", 14.3),
                stage("Arzua", "Arzua, A Coruna, Galicia, Spain", "Arca, O Pino", "O Pedrouzo, O Pino, A Coruna, Galicia, Spain", 18.5),
                stage("Arca, O Pino", "O Pedrouzo, O Pino, A Coruna, Galicia, Spain", "Santiago de Compostela", "Santiago de Compostela, Galicia, Spain", 20.2)
            ]
        ),
        OfficialRoute(
            id: .norte,
            name: "Camino del Norte",
            origin: "The Cantabrian coast toward Galicia",
            shortDescription: "A coastal journey with dramatic landscapes, a strong sense of distance and a wilder rhythm.",
            terrain: "Sea views, green hills, demanding stages and an experience that feels more rugged than the inland classics.",
            officialContext: "One of the major historic routes, known for tracing the northern edge of the peninsula before turning toward Santiago.",
            stages: [
                stage("Ribadeo", "Ribadeo, Lugo, Galicia, Spain", "Vilanova de Lourenza", "Vilanova de Lourenza, Lugo, Galicia, Spain", 27.9),
                stage("Vilanova de Lourenza", "Vilanova de Lourenza, Lugo, Galicia, Spain", "Abadin", "Abadin, Lugo, Galicia, Spain", 21.5),
                stage("Abadin", "Abadin, Lugo, Galicia, Spain", "Vilalba", "Vilalba, Lugo, Galicia, Spain", 20.3),
                stage("Vilalba", "Vilalba, Lugo, Galicia, Spain", "Baamonde", "Baamonde, Lugo, Galicia, Spain", 19.1),
                stage("Baamonde", "Baamonde, Lugo, Galicia, Spain", "Sobrado dos Monxes", "Sobrado dos Monxes, A Coruna, Galicia, Spain", 40.3),
                stage("Sobrado dos Monxes", "Sobrado dos Monxes, A Coruna, Galicia, Spain", "Arzua", "Arzua, A Coruna, Galicia, Spain", 21.9),
                stage("Arzua", "Arzua, A Coruna, Galicia, Spain", "Arca, O Pino", "O Pedrouzo, O Pino, A Coruna, Galicia, Spain", 18.5),
                stage("Arca, O Pino", "O Pedrouzo, O Pino, A Coruna, Galicia, Spain", "Santiago de Compostela", "Santiago de Compostela, Galicia, Spain", 20.2)
            ]
        ),
        OfficialRoute(
            id: .primitivo,
            name: "Camino Primitivo",
            origin: "Oviedo to Santiago",
            shortDescription: "The oldest documented Camino, chosen by pilgrims who want history and mountain character.",
            terrain: "Demanding elevation, quieter stages and a more introspective atmosphere before joining later pilgrim flows.",
            officialContext: "Traditionally linked to the earliest pilgrimage route associated with the first royal journeys toward Santiago.",
            stages: [
                stage("O Acevo", "Alto do Acevo, A Fonsagrada, Lugo, Galicia, Spain", "Paradavella", "Paradavella, A Fonsagrada, Lugo, Galicia, Spain", 24.5),
                stage("Paradavella", "Paradavella, Lugo, Galicia, Spain", "Castroverde", "Castroverde, Lugo, Galicia, Spain", 19.6),
                stage("Castroverde", "Castroverde, Lugo, Galicia, Spain", "Lugo", "Lugo, Galicia, Spain", 22.0),
                stage("Lugo", "Lugo, Galicia, Spain", "San Romao da Retorta", "San Romao da Retorta, Guntin, Lugo, Galicia, Spain", 18.8),
                stage("San Romao da Retorta", "San Romao da Retorta, Guntin, Lugo, Galicia, Spain", "Melide", "Melide, A Coruna, Galicia, Spain", 28.2),
                stage("Melide", "Melide, A Coruna, Galicia, Spain", "Arzua", "Arzua, A Coruna, Galicia, Spain", 14.3),
                stage("Arzua", "Arzua, A Coruna, Galicia, Spain", "Arca, O Pino", "O Pedrouzo, O Pino, A Coruna, Galicia, Spain", 18.5),
                stage("Arca, O Pino", "O Pedrouzo, O Pino, A Coruna, Galicia, Spain", "Santiago de Compostela", "Santiago de Compostela, Galicia, Spain", 20.2)
            ]
        ),
        OfficialRoute(
            id: .ingles,
            name: "Camino Ingles",
            origin: "Ferrol or A Coruna to Santiago",
            shortDescription: "A shorter route with maritime roots, ideal for pilgrims arriving by sea or looking for a compact Camino.",
            terrain: "Urban departure, estuaries, green inland stretches and a fast transition from coast to Compostela.",
            officialContext: "Its identity is tied to pilgrims from northern Europe who historically reached Galicia by ship.",
            stages: [
                stage("Ferrol", "Ferrol, A Coruna, Galicia, Spain", "Neda", "Neda, A Coruna, Galicia, Spain", 15.4),
                stage("Neda", "Neda, A Coruna, Galicia, Spain", "Mino", "Mino, A Coruna, Galicia, Spain", 22.1),
                stage("Mino", "Mino, A Coruna, Galicia, Spain", "Bruma", "Hospital de Bruma, Mesia, A Coruna, Galicia, Spain", 34.8),
                stage("Bruma", "Hospital de Bruma, Mesia, A Coruna, Galicia, Spain", "Sigueiro", "Sigueiro, Oroso, A Coruna, Galicia, Spain", 24.2),
                stage("Sigueiro", "Sigueiro, Oroso, A Coruna, Galicia, Spain", "Santiago de Compostela", "Santiago de Compostela, Galicia, Spain", 16.1)
            ]
        ),
        OfficialRoute(
            id: .portugues,
            name: "Camino Portugues",
            origin: "Lisbon or Porto through Tui",
            shortDescription: "A smooth, social and highly popular Camino with deep cross-border identity between Portugal and Galicia.",
            terrain: "Stone villages, river crossings, balanced stages and one of the most accessible day-to-day walking experiences.",
            officialContext: "It grew in relevance through the historic links between Portugal and Galicia and remains one of the strongest contemporary routes.",
            stages: [
                stage("Tui", "Tui, Pontevedra, Galicia, Spain", "O Porrino", "O Porrino, Pontevedra, Galicia, Spain", 18.1),
                stage("O Porrino", "O Porrino, Pontevedra, Galicia, Spain", "Redondela", "Redondela, Pontevedra, Galicia, Spain", 15.0),
                stage("Redondela", "Redondela, Pontevedra, Galicia, Spain", "Pontevedra", "Pontevedra, Galicia, Spain", 18.0),
                stage("Pontevedra", "Pontevedra, Galicia, Spain", "Caldas de Reis", "Caldas de Reis, Pontevedra, Galicia, Spain", 22.8),
                stage("Caldas de Reis", "Caldas de Reis, Pontevedra, Galicia, Spain", "Padron", "Padron, A Coruna, Galicia, Spain", 18.7),
                stage("Padron", "Padron, A Coruna, Galicia, Spain", "Santiago de Compostela", "Santiago de Compostela, Galicia, Spain", 24.9)
            ]
        ),
        OfficialRoute(
            id: .portuguesCoastal,
            name: "Camino Portugues de la Costa",
            origin: "Atlantic coast through A Guarda",
            shortDescription: "A bright coastal alternative shaped by estuaries, promenade towns and Atlantic energy.",
            terrain: "Coastal passages, fishing towns, open horizons and a route that gradually bends inland toward Santiago.",
            officialContext: "Recognized as an official variant that preserves the Portuguese Camino identity while emphasizing the Atlantic shoreline.",
            stages: [
                stage("A Guarda", "A Guarda, Pontevedra, Galicia, Spain", "Oia", "Oia, Pontevedra, Galicia, Spain", 16.7),
                stage("Oia", "Oia, Pontevedra, Galicia, Spain", "Baiona", "Baiona, Pontevedra, Galicia, Spain", 18.7),
                stage("Baiona", "Baiona, Pontevedra, Galicia, Spain", "Vigo", "Vigo, Pontevedra, Galicia, Spain", 27.1),
                stage("Vigo", "Vigo, Pontevedra, Galicia, Spain", "Redondela", "Redondela, Pontevedra, Galicia, Spain", 15.7),
                stage("Redondela", "Redondela, Pontevedra, Galicia, Spain", "Pontevedra", "Pontevedra, Galicia, Spain", 18.0),
                stage("Pontevedra", "Pontevedra, Galicia, Spain", "Caldas de Reis", "Caldas de Reis, Pontevedra, Galicia, Spain", 22.8),
                stage("Caldas de Reis", "Caldas de Reis, Pontevedra, Galicia, Spain", "Padron", "Padron, A Coruna, Galicia, Spain", 18.7),
                stage("Padron", "Padron, A Coruna, Galicia, Spain", "Santiago de Compostela", "Santiago de Compostela, Galicia, Spain", 24.9)
            ]
        ),
        OfficialRoute(
            id: .viaDeLaPlata,
            name: "Via de la Plata",
            origin: "Southern Iberia through Ourense",
            shortDescription: "A long southern approach for pilgrims who want scale, endurance and a strong sense of continental distance.",
            terrain: "Open landscapes, inland towns and a slower, expansive progression before entering the Galician network.",
            officialContext: "Also associated with the Mozarabic tradition, it represents one of the great long-distance southern approaches to Santiago.",
            stages: [
                stage("A Gudina", "A Gudina, Ourense, Galicia, Spain", "Laza", "Laza, Ourense, Galicia, Spain", 34.0),
                stage("Laza", "Laza, Ourense, Galicia, Spain", "Ourense", "Ourense, Galicia, Spain", 58.0),
                stage("Ourense", "Ourense, Galicia, Spain", "San Cristovo de Cea", "San Cristovo de Cea, Ourense, Galicia, Spain", 22.8),
                stage("San Cristovo de Cea", "San Cristovo de Cea, Ourense, Galicia, Spain", "Bendoiro", "Bendoiro, Lalin, Pontevedra, Galicia, Spain", 34.0),
                stage("Bendoiro", "Bendoiro, Lalin, Pontevedra, Galicia, Spain", "Outeiro", "Outeiro, Silleda, Pontevedra, Galicia, Spain", 33.8),
                stage("Outeiro", "Outeiro, Silleda, Pontevedra, Galicia, Spain", "Santiago de Compostela", "Santiago de Compostela, Galicia, Spain", 16.6)
            ]
        ),
        OfficialRoute(
            id: .invierno,
            name: "Camino de Invierno",
            origin: "Ponferrada through Valdeorras",
            shortDescription: "An inland alternative built for pilgrims who want a calmer route with remarkable valley and vineyard scenery.",
            terrain: "River valleys, inland Galicia, gentler winter logic and a distinctive passage through the southeast.",
            officialContext: "Historically understood as an alternative to avoid the hardest winter conditions of the higher mountain approach.",
            stages: [
                stage("Ponferrada", "Ponferrada, Leon, Spain", "O Barco de Valdeorras", "O Barco de Valdeorras, Ourense, Galicia, Spain", 53.5),
                stage("O Barco de Valdeorras", "O Barco de Valdeorras, Ourense, Galicia, Spain", "A Rua", "A Rua, Ourense, Galicia, Spain", 13.4),
                stage("A Rua", "A Rua, Ourense, Galicia, Spain", "Quiroga", "Quiroga, Lugo, Galicia, Spain", 26.5),
                stage("Quiroga", "Quiroga, Lugo, Galicia, Spain", "Monforte de Lemos", "Monforte de Lemos, Lugo, Galicia, Spain", 35.2),
                stage("Monforte de Lemos", "Monforte de Lemos, Lugo, Galicia, Spain", "Chantada", "Chantada, Lugo, Galicia, Spain", 30.9),
                stage("Chantada", "Chantada, Lugo, Galicia, Spain", "Rodeiro", "Rodeiro, Pontevedra, Galicia, Spain", 25.7),
                stage("Rodeiro", "Rodeiro, Pontevedra, Galicia, Spain", "Bendoiro", "Bendoiro, Lalin, Pontevedra, Galicia, Spain", 26.8),
                stage("Bendoiro", "Bendoiro, Lalin, Pontevedra, Galicia, Spain", "Outeiro", "Outeiro, Silleda, Pontevedra, Galicia, Spain", 33.8),
                stage("Outeiro", "Outeiro, Silleda, Pontevedra, Galicia, Spain", "Santiago de Compostela", "Santiago de Compostela, Galicia, Spain", 16.6)
            ]
        ),
        OfficialRoute(
            id: .fisterraMuxia,
            name: "Camino de Fisterra-Muxia",
            origin: "From Santiago to the Atlantic",
            shortDescription: "The route that extends the pilgrimage beyond Compostela all the way to the ocean edge.",
            terrain: "A post-arrival Camino with Atlantic light, symbolic endings and a very different emotional cadence.",
            officialContext: "It is singular within the Jacobean network because it begins after reaching Santiago and projects the experience toward the coast.",
            stages: [
                stage("Santiago de Compostela", "Santiago de Compostela, Galicia, Spain", "Negreira", "Negreira, A Coruna, Galicia, Spain", 21.0),
                stage("Negreira", "Negreira, A Coruna, Galicia, Spain", "Olveiroa", "Olveiroa, Dumbria, A Coruna, Galicia, Spain", 33.0),
                stage("Olveiroa", "Olveiroa, Dumbria, A Coruna, Galicia, Spain", "Fisterra", "Fisterra, A Coruna, Galicia, Spain", 34.0),
                stage("Fisterra", "Fisterra, A Coruna, Galicia, Spain", "Muxia", "Muxia, A Coruna, Galicia, Spain", 28.7)
            ]
        ),
        OfficialRoute(
            id: .arousaUlla,
            name: "Ruta del Mar de Arousa y Rio Ulla",
            origin: "Maritime-fluvial entry through the Arousa estuary",
            shortDescription: "A route centered on water, memory and the symbolic arrival linked to the Jacobean tradition.",
            terrain: "Boat symbolism, estuary culture and a narrative built around the final inland approach along the Ulla river.",
            officialContext: "It commemorates the maritime and river journey associated with the tradition of the Apostle's arrival in Galicia.",
            stages: [
                stage("Ribeira", "Ribeira, A Coruna, Galicia, Spain", "Padron", "Padron, A Coruna, Galicia, Spain", 74.1, mode: .maritime),
                stage("Padron", "Padron, A Coruna, Galicia, Spain", "Santiago de Compostela", "Santiago de Compostela, Galicia, Spain", 24.8)
            ]
        )
    ]

}

private let routeStopCoordinatesByQuery: [String: OfficialRoute.Coordinate] = [
    "O Cebreiro, Lugo, Galicia, Spain": .init(latitude: 42.7078, longitude: -7.0439),
    "Triacastela, Lugo, Galicia, Spain": .init(latitude: 42.7571, longitude: -7.2398),
    "Sarria, Lugo, Galicia, Spain": .init(latitude: 42.7812, longitude: -7.4140),
    "Portomarin, Lugo, Galicia, Spain": .init(latitude: 42.8078, longitude: -7.6158),
    "Palas de Rei, Lugo, Galicia, Spain": .init(latitude: 42.8744, longitude: -7.8686),
    "Melide, A Coruna, Galicia, Spain": .init(latitude: 42.9146, longitude: -8.0141),
    "Arzua, A Coruna, Galicia, Spain": .init(latitude: 42.9281, longitude: -8.1642),
    "O Pedrouzo, O Pino, A Coruna, Galicia, Spain": .init(latitude: 42.9047, longitude: -8.3643),
    "Santiago de Compostela, Galicia, Spain": .init(latitude: 42.8805, longitude: -8.5457),
    "Ribadeo, Lugo, Galicia, Spain": .init(latitude: 43.5373, longitude: -7.0407),
    "Vilanova de Lourenza, Lugo, Galicia, Spain": .init(latitude: 43.4696, longitude: -7.3009),
    "Abadin, Lugo, Galicia, Spain": .init(latitude: 43.3663, longitude: -7.4765),
    "Vilalba, Lugo, Galicia, Spain": .init(latitude: 43.2957, longitude: -7.6813),
    "Baamonde, Lugo, Galicia, Spain": .init(latitude: 43.1743, longitude: -7.7574),
    "Sobrado dos Monxes, A Coruna, Galicia, Spain": .init(latitude: 43.0392, longitude: -8.0278),
    "Alto do Acevo, A Fonsagrada, Lugo, Galicia, Spain": .init(latitude: 43.1231, longitude: -7.0640),
    "Paradavella, A Fonsagrada, Lugo, Galicia, Spain": .init(latitude: 43.0838, longitude: -7.0898),
    "Castroverde, Lugo, Galicia, Spain": .init(latitude: 43.0312, longitude: -7.3274),
    "Lugo, Galicia, Spain": .init(latitude: 43.0121, longitude: -7.5560),
    "San Romao da Retorta, Guntin, Lugo, Galicia, Spain": .init(latitude: 42.9970, longitude: -7.7370),
    "Ferrol, A Coruna, Galicia, Spain": .init(latitude: 43.4840, longitude: -8.2369),
    "Neda, A Coruna, Galicia, Spain": .init(latitude: 43.4994, longitude: -8.1561),
    "Mino, A Coruna, Galicia, Spain": .init(latitude: 43.3475, longitude: -8.2068),
    "Hospital de Bruma, Mesia, A Coruna, Galicia, Spain": .init(latitude: 43.0930, longitude: -8.3395),
    "Sigueiro, Oroso, A Coruna, Galicia, Spain": .init(latitude: 42.9667, longitude: -8.4363),
    "Tui, Pontevedra, Galicia, Spain": .init(latitude: 42.0464, longitude: -8.6436),
    "O Porrino, Pontevedra, Galicia, Spain": .init(latitude: 42.1613, longitude: -8.6197),
    "Redondela, Pontevedra, Galicia, Spain": .init(latitude: 42.2838, longitude: -8.6074),
    "Pontevedra, Galicia, Spain": .init(latitude: 42.4310, longitude: -8.6444),
    "Caldas de Reis, Pontevedra, Galicia, Spain": .init(latitude: 42.6058, longitude: -8.6416),
    "Padron, A Coruna, Galicia, Spain": .init(latitude: 42.7380, longitude: -8.6606),
    "A Guarda, Pontevedra, Galicia, Spain": .init(latitude: 41.9024, longitude: -8.8742),
    "Oia, Pontevedra, Galicia, Spain": .init(latitude: 42.0035, longitude: -8.8754),
    "Baiona, Pontevedra, Galicia, Spain": .init(latitude: 42.1182, longitude: -8.8504),
    "Vigo, Pontevedra, Galicia, Spain": .init(latitude: 42.2406, longitude: -8.7207),
    "A Gudina, Ourense, Galicia, Spain": .init(latitude: 42.0617, longitude: -7.1388),
    "Laza, Ourense, Galicia, Spain": .init(latitude: 42.0616, longitude: -7.4628),
    "Ourense, Galicia, Spain": .init(latitude: 42.3365, longitude: -7.8637),
    "San Cristovo de Cea, Ourense, Galicia, Spain": .init(latitude: 42.4744, longitude: -7.9857),
    "Bendoiro, Lalin, Pontevedra, Galicia, Spain": .init(latitude: 42.6617, longitude: -8.1129),
    "Outeiro, Silleda, Pontevedra, Galicia, Spain": .init(latitude: 42.7062, longitude: -8.2525),
    "Ponferrada, Leon, Spain": .init(latitude: 42.5460, longitude: -6.5900),
    "O Barco de Valdeorras, Ourense, Galicia, Spain": .init(latitude: 42.4168, longitude: -6.9902),
    "A Rua, Ourense, Galicia, Spain": .init(latitude: 42.3934, longitude: -7.1146),
    "Quiroga, Lugo, Galicia, Spain": .init(latitude: 42.4757, longitude: -7.2742),
    "Monforte de Lemos, Lugo, Galicia, Spain": .init(latitude: 42.5185, longitude: -7.5115),
    "Chantada, Lugo, Galicia, Spain": .init(latitude: 42.6089, longitude: -7.7700),
    "Rodeiro, Pontevedra, Galicia, Spain": .init(latitude: 42.6517, longitude: -7.9499),
    "Negreira, A Coruna, Galicia, Spain": .init(latitude: 42.9043, longitude: -8.7359),
    "Olveiroa, Dumbria, A Coruna, Galicia, Spain": .init(latitude: 42.9814, longitude: -9.0196),
    "Fisterra, A Coruna, Galicia, Spain": .init(latitude: 42.9049, longitude: -9.2629),
    "Muxia, A Coruna, Galicia, Spain": .init(latitude: 43.1043, longitude: -9.2176),
    "Ribeira, A Coruna, Galicia, Spain": .init(latitude: 42.5618, longitude: -8.9902)
]

private func stage(
    _ startName: String,
    _ startQuery: String,
    _ endName: String,
    _ endQuery: String,
    _ distanceKilometers: Double,
    mode: OfficialRoute.StageMode = .walking
) -> OfficialRoute.Stage {
    OfficialRoute.Stage(
        start: OfficialRoute.Stop(
            name: startName,
            searchQuery: startQuery,
            coordinate: routeStopCoordinatesByQuery[startQuery]
        ),
        end: OfficialRoute.Stop(
            name: endName,
            searchQuery: endQuery,
            coordinate: routeStopCoordinatesByQuery[endQuery]
        ),
        distanceKilometers: distanceKilometers,
        mode: mode
    )
}
