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
            officialContext: "Widely recognized as the best-known Jacobean route and one of the central historic backbones of the Camino."
        ),
        OfficialRoute(
            id: .norte,
            name: "Camino del Norte",
            origin: "The Cantabrian coast toward Galicia",
            shortDescription: "A coastal journey with dramatic landscapes, a strong sense of distance and a wilder rhythm.",
            terrain: "Sea views, green hills, demanding stages and an experience that feels more rugged than the inland classics.",
            officialContext: "One of the major historic routes, known for tracing the northern edge of the peninsula before turning toward Santiago."
        ),
        OfficialRoute(
            id: .primitivo,
            name: "Camino Primitivo",
            origin: "Oviedo to Santiago",
            shortDescription: "The oldest documented Camino, chosen by pilgrims who want history and mountain character.",
            terrain: "Demanding elevation, quieter stages and a more introspective atmosphere before joining later pilgrim flows.",
            officialContext: "Traditionally linked to the earliest pilgrimage route associated with the first royal journeys toward Santiago."
        ),
        OfficialRoute(
            id: .ingles,
            name: "Camino Ingles",
            origin: "Ferrol or A Coruna to Santiago",
            shortDescription: "A shorter route with maritime roots, ideal for pilgrims arriving by sea or looking for a compact Camino.",
            terrain: "Urban departure, estuaries, green inland stretches and a fast transition from coast to Compostela.",
            officialContext: "Its identity is tied to pilgrims from northern Europe who historically reached Galicia by ship."
        ),
        OfficialRoute(
            id: .portugues,
            name: "Camino Portugues",
            origin: "Lisbon or Porto through Tui",
            shortDescription: "A smooth, social and highly popular Camino with deep cross-border identity between Portugal and Galicia.",
            terrain: "Stone villages, river crossings, balanced stages and one of the most accessible day-to-day walking experiences.",
            officialContext: "It grew in relevance through the historic links between Portugal and Galicia and remains one of the strongest contemporary routes."
        ),
        OfficialRoute(
            id: .portuguesCoastal,
            name: "Camino Portugues de la Costa",
            origin: "Atlantic coast through A Guarda",
            shortDescription: "A bright coastal alternative shaped by estuaries, promenade towns and Atlantic energy.",
            terrain: "Coastal passages, fishing towns, open horizons and a route that gradually bends inland toward Santiago.",
            officialContext: "Recognized as an official variant that preserves the Portuguese Camino identity while emphasizing the Atlantic shoreline."
        ),
        OfficialRoute(
            id: .viaDeLaPlata,
            name: "Via de la Plata",
            origin: "Southern Iberia through Ourense",
            shortDescription: "A long southern approach for pilgrims who want scale, endurance and a strong sense of continental distance.",
            terrain: "Open landscapes, inland towns and a slower, expansive progression before entering the Galician network.",
            officialContext: "Also associated with the Mozarabic tradition, it represents one of the great long-distance southern approaches to Santiago."
        ),
        OfficialRoute(
            id: .invierno,
            name: "Camino de Invierno",
            origin: "Ponferrada through Valdeorras",
            shortDescription: "An inland alternative built for pilgrims who want a calmer route with remarkable valley and vineyard scenery.",
            terrain: "River valleys, inland Galicia, gentler winter logic and a distinctive passage through the southeast.",
            officialContext: "Historically understood as an alternative to avoid the hardest winter conditions of the higher mountain approach."
        ),
        OfficialRoute(
            id: .fisterraMuxia,
            name: "Camino de Fisterra-Muxia",
            origin: "From Santiago to the Atlantic",
            shortDescription: "The route that extends the pilgrimage beyond Compostela all the way to the ocean edge.",
            terrain: "A post-arrival Camino with Atlantic light, symbolic endings and a very different emotional cadence.",
            officialContext: "It is singular within the Jacobean network because it begins after reaching Santiago and projects the experience toward the coast."
        ),
        OfficialRoute(
            id: .arousaUlla,
            name: "Ruta del Mar de Arousa y Rio Ulla",
            origin: "Maritime-fluvial entry through the Arousa estuary",
            shortDescription: "A route centered on water, memory and the symbolic arrival linked to the Jacobean tradition.",
            terrain: "Boat symbolism, estuary culture and a narrative built around the final inland approach along the Ulla river.",
            officialContext: "It commemorates the maritime and river journey associated with the tradition of the Apostle's arrival in Galicia."
        )
    ]
}
