import Foundation

/// Official Camino route with stops, stages and localized descriptive content.
struct OfficialRoute: Identifiable, Equatable, Sendable {
    /// Travel mode used by a route stage.
    enum StageMode: String, Sendable {
        case walking
        case maritime
    }

    /// Stable route identifiers used for navigation and persistence.
    enum ID: String, CaseIterable, Hashable, Codable, Sendable {
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

    /// Lightweight coordinate representation kept independent from MapKit.
    struct Coordinate: Hashable, Sendable {
        let latitude: Double
        let longitude: Double
    }

    /// Named place used as a stage start or end.
    struct Stop: Identifiable, Hashable, Sendable {
        let name: String
        let searchQuery: String
        let coordinate: Coordinate?

        var id: String {
            searchQuery
        }
    }

    /// One route segment with distance and movement mode.
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

    // MARK: - Derived Values

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

    // MARK: - Localization

    func localizedName(for language: AppLanguage) -> String {
        id.localizedContent(for: language).name
    }

    func localizedOrigin(for language: AppLanguage) -> String {
        id.localizedContent(for: language).origin
    }

    func localizedShortDescription(for language: AppLanguage) -> String {
        id.localizedContent(for: language).shortDescription
    }

    func localizedTerrain(for language: AppLanguage) -> String {
        id.localizedContent(for: language).terrain
    }

    func localizedOfficialContext(for language: AppLanguage) -> String {
        id.localizedContent(for: language).officialContext
    }
}

/// Localized text bundle for route metadata.
private struct OfficialRouteLocalizedContent {
    let name: String
    let origin: String
    let shortDescription: String
    let terrain: String
    let officialContext: String
}

// MARK: - Localized Content

extension OfficialRoute.ID {
    fileprivate func localizedContent(for language: AppLanguage) -> OfficialRouteLocalizedContent {
        switch language {
        case .spanish:
            switch self {
            case .frances: .init(name: "Camino Frances", origin: "Desde Roncesvalles o Somport hacia Santiago", shortDescription: "La ruta jacobea más icónica y la puerta de entrada más clara para muchos peregrinos primerizos.", terrain: "Pueblos históricos, gran infraestructura peregrina y una progresión clásica hacia Galicia por O Cebreiro.", officialContext: "Está ampliamente reconocida como la ruta jacobea más conocida y uno de los grandes ejes históricos del Camino.")
            case .norte: .init(name: "Camino del Norte", origin: "La costa cantábrica hacia Galicia", shortDescription: "Un recorrido costero con paisajes intensos, sensación de distancia y un ritmo más salvaje.", terrain: "Vistas al mar, colinas verdes, etapas exigentes y una experiencia más agreste que las rutas interiores clásicas.", officialContext: "Es una de las grandes rutas históricas y sigue el borde norte de la península antes de girar hacia Santiago.")
            case .primitivo: .init(name: "Camino Primitivo", origin: "De Oviedo a Santiago", shortDescription: "El Camino documentado más antiguo, ideal para peregrinos que buscan historia y montaña.", terrain: "Desnivel exigente, etapas más silenciosas y una atmósfera introspectiva antes de unirse a otros flujos peregrinos.", officialContext: "Tradicionalmente se vincula con la ruta de peregrinación más antigua asociada a los primeros viajes regios hacia Santiago.")
            case .ingles: .init(name: "Camino Ingles", origin: "Desde Ferrol o A Coruna a Santiago", shortDescription: "Una ruta más corta y de raíz marítima, ideal para quien busca un Camino compacto.", terrain: "Salida urbana, rías, tramos verdes de interior y una transición rápida de la costa a Compostela.", officialContext: "Su identidad está ligada a los peregrinos del norte de Europa que históricamente llegaban por mar a Galicia.")
            case .portugues: .init(name: "Camino Portugues", origin: "Desde Lisboa o Porto por Tui", shortDescription: "Un Camino fluido, social y muy popular, con fuerte identidad transfronteriza entre Portugal y Galicia.", terrain: "Pueblos de piedra, cruces de río, etapas equilibradas y una experiencia de marcha muy accesible.", officialContext: "Creció por los lazos históricos entre Portugal y Galicia y hoy es una de las rutas más fuertes del Camino contemporáneo.")
            case .portuguesCoastal: .init(name: "Camino Portugues de la Costa", origin: "Costa atlántica por A Guarda", shortDescription: "Una alternativa luminosa y costera, marcada por rías, villas marítimas y energía atlántica.", terrain: "Pasos junto al mar, pueblos pesqueros, horizontes abiertos y un giro progresivo hacia el interior.", officialContext: "Está reconocida como variante oficial del Camino Portugués con protagonismo claro del litoral atlántico.")
            case .viaDeLaPlata: .init(name: "Via de la Plata", origin: "Sur peninsular por Ourense", shortDescription: "Una gran aproximación sureña para quien busca escala, resistencia y sensación de travesía continental.", terrain: "Paisajes abiertos, núcleos interiores y una progresión lenta y expansiva antes de entrar en Galicia.", officialContext: "También vinculada a la tradición mozárabe, representa una de las grandes entradas históricas del sur hacia Santiago.")
            case .invierno: .init(name: "Camino de Invierno", origin: "Desde Ponferrada por Valdeorras", shortDescription: "Una alternativa interior para quien quiere calma, valles y paisaje de viñedo.", terrain: "Valles fluviales, interior gallego y una lógica más amable para el invierno por el sureste.", officialContext: "Se entiende históricamente como una alternativa para evitar las condiciones más duras de la alta montaña en invierno.")
            case .fisterraMuxia: .init(name: "Camino de Fisterra-Muxia", origin: "De Santiago hacia el Atlántico", shortDescription: "La ruta que prolonga la peregrinación más allá de Compostela hasta el borde del océano.", terrain: "Un Camino post-llegada con luz atlántica, finales simbólicos y una cadencia emocional distinta.", officialContext: "Es singular dentro de la red jacobea porque comienza tras llegar a Santiago y proyecta la experiencia hacia la costa.")
            case .arousaUlla: .init(name: "Ruta del Mar de Arousa y Rio Ulla", origin: "Entrada marítimo-fluvial por la ría de Arousa", shortDescription: "Una ruta marcada por el agua, la memoria y la llegada simbólica vinculada a la tradición jacobea.", terrain: "Simbolismo náutico, cultura de estuario y relato construido sobre la remontada final del Ulla.", officialContext: "Conmemora el viaje marítimo y fluvial asociado a la tradición de la llegada del Apóstol a Galicia.")
            }
        case .french:
            switch self {
            case .frances: .init(name: "Camino Francais", origin: "Depuis Roncevaux ou Somport vers Saint-Jacques", shortDescription: "L'itineraire le plus iconique et l'entree la plus claire pour beaucoup de premiers pelerins.", terrain: "Villes historiques, forte infrastructure pelerine et progression classique vers la Galice par O Cebreiro.", officialContext: "Il est largement reconnu comme la route jacquaire la plus celebre et l'un des grands axes historiques du Camino.")
            case .norte: .init(name: "Camino del Norte", origin: "La cote cantabrique vers la Galice", shortDescription: "Un voyage cotier aux paysages marquants, avec une vraie sensation de distance.", terrain: "Vues marines, collines vertes, etapes exigeantes et experience plus sauvage que les routes interieures.", officialContext: "C'est l'une des grandes routes historiques, longeant le nord de la peninsule avant de tourner vers Saint-Jacques.")
            case .primitivo: .init(name: "Camino Primitivo", origin: "D'Oviedo a Saint-Jacques", shortDescription: "Le Camino le plus anciennement documente, pour ceux qui cherchent histoire et montagne.", terrain: "Denivele exigeant, etapes plus calmes et atmosphere introspective avant de rejoindre d'autres flux pelerins.", officialContext: "Il est traditionnellement lie au premier itineraire de pelerinage associe aux voyages royaux vers Saint-Jacques.")
            case .ingles: .init(name: "Camino Ingles", origin: "Depuis Ferrol ou A Coruna vers Saint-Jacques", shortDescription: "Une route plus courte et maritime, ideale pour un Camino compact.", terrain: "Depart urbain, estuaires, troncons verts et transition rapide de la cote a Compostelle.", officialContext: "Son identite est liee aux pelerins d'Europe du Nord qui arrivaient historiquement en Galice par bateau.")
            case .portugues: .init(name: "Camino Portugais", origin: "Depuis Lisbonne ou Porto via Tui", shortDescription: "Un Camino fluide, social et tres populaire, marque par l'identite entre Portugal et Galice.", terrain: "Villages de pierre, passages de rivieres et etapes equilibrees pour une marche tres accessible.", officialContext: "Il s'est renforce grace aux liens historiques entre le Portugal et la Galice et reste l'une des routes majeures aujourd'hui.")
            case .portuguesCoastal: .init(name: "Camino Portugais de la Cote", origin: "Cote atlantique via A Guarda", shortDescription: "Une alternative cotiere lumineuse, faconnee par les estuaires et les villes maritimes.", terrain: "Passages cotiers, villages de pecheurs, horizons ouverts et courbe progressive vers l'interieur.", officialContext: "Elle est reconnue comme variante officielle du Camino Portugais avec un fort accent atlantique.")
            case .viaDeLaPlata: .init(name: "Via de la Plata", origin: "Sud iberique via Ourense", shortDescription: "Une grande approche meridionale pour qui cherche l'endurance et une sensation de longue traversee.", terrain: "Paysages ouverts, villes interieures et progression lente avant d'entrer dans le reseau galicien.", officialContext: "Associee aussi a la tradition mozarabe, elle represente l'une des grandes entrees historiques du sud vers Saint-Jacques.")
            case .invierno: .init(name: "Camino de Invierno", origin: "Depuis Ponferrada via Valdeorras", shortDescription: "Une alternative interieure plus calme, avec vallees et paysages de vigne.", terrain: "Vallees fluviales, Galice interieure et logique hivernale plus douce par le sud-est.", officialContext: "Historiquement, elle servait d'alternative pour eviter les conditions les plus dures des hautes montagnes en hiver.")
            case .fisterraMuxia: .init(name: "Camino de Fisterra-Muxia", origin: "De Saint-Jacques vers l'Atlantique", shortDescription: "La route qui prolonge le pelerinage au-dela de Compostelle jusqu'au bord de l'ocean.", terrain: "Un Camino apres l'arrivee, avec lumiere atlantique et finalites symboliques.", officialContext: "Elle est singuliere car elle commence apres l'arrivee a Saint-Jacques et prolonge l'experience vers la cote.")
            case .arousaUlla: .init(name: "Route de la mer d'Arousa et du Rio Ulla", origin: "Entree maritime et fluviale par l'estuaire d'Arousa", shortDescription: "Une route centree sur l'eau, la memoire et une arrivee symbolique de la tradition jacquaire.", terrain: "Symbolique nautique, culture d'estuaire et progression finale le long de l'Ulla.", officialContext: "Elle commemore le voyage maritime et fluvial associe a la tradition de l'arrivee de l'Apotre en Galice.")
            }
        case .english, .system:
            switch self {
            case .frances: .init(name: "Camino Frances", origin: "Roncesvalles or Somport toward Santiago", shortDescription: "The iconic Camino route and the clearest entry point for many first-time pilgrims.", terrain: "Historic towns, strong pilgrim infrastructure and a classic progression into Galicia through O Cebreiro.", officialContext: "Widely recognized as the best-known Jacobean route and one of the central historic backbones of the Camino.")
            case .norte: .init(name: "Camino del Norte", origin: "The Cantabrian coast toward Galicia", shortDescription: "A coastal journey with dramatic landscapes, a strong sense of distance and a wilder rhythm.", terrain: "Sea views, green hills, demanding stages and an experience that feels more rugged than the inland classics.", officialContext: "One of the major historic routes, known for tracing the northern edge of the peninsula before turning toward Santiago.")
            case .primitivo: .init(name: "Camino Primitivo", origin: "Oviedo to Santiago", shortDescription: "The oldest documented Camino, chosen by pilgrims who want history and mountain character.", terrain: "Demanding elevation, quieter stages and a more introspective atmosphere before joining later pilgrim flows.", officialContext: "Traditionally linked to the earliest pilgrimage route associated with the first royal journeys toward Santiago.")
            case .ingles: .init(name: "Camino Ingles", origin: "Ferrol or A Coruna to Santiago", shortDescription: "A shorter route with maritime roots, ideal for pilgrims arriving by sea or looking for a compact Camino.", terrain: "Urban departure, estuaries, green inland stretches and a fast transition from coast to Compostela.", officialContext: "Its identity is tied to pilgrims from northern Europe who historically reached Galicia by ship.")
            case .portugues: .init(name: "Camino Portugues", origin: "Lisbon or Porto through Tui", shortDescription: "A smooth, social and highly popular Camino with deep cross-border identity between Portugal and Galicia.", terrain: "Stone villages, river crossings, balanced stages and one of the most accessible day-to-day walking experiences.", officialContext: "It grew in relevance through the historic links between Portugal and Galicia and remains one of the strongest contemporary routes.")
            case .portuguesCoastal: .init(name: "Camino Portugues de la Costa", origin: "Atlantic coast through A Guarda", shortDescription: "A bright coastal alternative shaped by estuaries, promenade towns and Atlantic energy.", terrain: "Coastal passages, fishing towns, open horizons and a route that gradually bends inland toward Santiago.", officialContext: "Recognized as an official variant that preserves the Portuguese Camino identity while emphasizing the Atlantic shoreline.")
            case .viaDeLaPlata: .init(name: "Via de la Plata", origin: "Southern Iberia through Ourense", shortDescription: "A long southern approach for pilgrims who want scale, endurance and a strong sense of continental distance.", terrain: "Open landscapes, inland towns and a slower, expansive progression before entering the Galician network.", officialContext: "Also associated with the Mozarabic tradition, it represents one of the great long-distance southern approaches to Santiago.")
            case .invierno: .init(name: "Camino de Invierno", origin: "Ponferrada through Valdeorras", shortDescription: "An inland alternative built for pilgrims who want a calmer route with remarkable valley and vineyard scenery.", terrain: "River valleys, inland Galicia, gentler winter logic and a distinctive passage through the southeast.", officialContext: "Historically understood as an alternative to avoid the hardest winter conditions of the higher mountain approach.")
            case .fisterraMuxia: .init(name: "Camino de Fisterra-Muxia", origin: "From Santiago to the Atlantic", shortDescription: "The route that extends the pilgrimage beyond Compostela all the way to the ocean edge.", terrain: "A post-arrival Camino with Atlantic light, symbolic endings and a very different emotional cadence.", officialContext: "It is singular within the Jacobean network because it begins after reaching Santiago and projects the experience toward the coast.")
            case .arousaUlla: .init(name: "Ruta del Mar de Arousa y Rio Ulla", origin: "Maritime-fluvial entry through the Arousa estuary", shortDescription: "A route centered on water, memory and the symbolic arrival linked to the Jacobean tradition.", terrain: "Boat symbolism, estuary culture and a narrative built around the final inland approach along the Ulla river.", officialContext: "It commemorates the maritime and river journey associated with the tradition of the Apostle's arrival in Galicia.")
            }
        }
    }
}
