import SwiftUI

struct AppStrings {
    let language: AppLanguage

    let tabHome: String
    let tabRoutes: String
    let tabSettings: String

    let homeLoading: String
    let homeUnavailable: String
    let homeHeroSubtitle: String
    let officialRoutesLabel: String
    let checkInsLabel: String
    let manualLabel: String
    let quickActionsTitle: String
    let exploreRoutesTitle: String
    let exploreRoutesSubtitle: String
    let groupsSoonTitle: String
    let groupsSoonSubtitle: String
    let featuredRoutesTitle: String
    let seeAll: String
    let routesCountValue: String
    let featuredFrancesSubtitle: String
    let featuredNorteSubtitle: String

    let routesLoading: String
    let routesTitle: String
    let routesSubtitle: String
    let sourceTitle: String
    let sourceValue: String
    let layersTitle: String
    let layersValue: String

    let routeLoading: String
    let routeUnavailable: String
    let routeNavigationTitle: String
    let originTitle: String
    let routeCharacterTitle: String
    let whyItMattersTitle: String
    let routeMapTitle: String
    let stopsLabel: String
    let routeMapUnavailableTitle: String
    let routeMapUnavailableMessage: String
    let stagesTitle: String
    let walkingStageLabel: String
    let maritimeSegmentLabel: String
    let stageStopLabel: String

    let settingsTitle: String
    let settingsSubtitle: String
    let languageSectionTitle: String
    let languageSectionSubtitle: String
    let appearanceSectionTitle: String
    let appearanceSectionSubtitle: String
    let previewSectionTitle: String
    let previewTitle: String
    let previewSubtitle: String
    let previewBadge: String
    let personalizedCopyTitle: String
    let personalizedCopySubtitle: String

    let systemLabel: String
    let englishLabel: String
    let spanishLabel: String
    let frenchLabel: String
    let lightLabel: String
    let darkLabel: String

    static func make(for language: AppLanguage) -> AppStrings {
        switch language {
        case .spanish:
            .spanish
        case .french:
            .french
        case .system, .english:
            .english
        }
    }

    func languageLabel(for option: AppLanguage) -> String {
        switch option {
        case .system:
            systemLabel
        case .english:
            englishLabel
        case .spanish:
            spanishLabel
        case .french:
            frenchLabel
        }
    }

    func appearanceLabel(for option: AppAppearance) -> String {
        switch option {
        case .system:
            systemLabel
        case .light:
            lightLabel
        case .dark:
            darkLabel
        }
    }
}

extension AppStrings {
    static let english = AppStrings(
        language: .english,
        tabHome: "Home",
        tabRoutes: "Routes",
        tabSettings: "Settings",
        homeLoading: "Loading home",
        homeUnavailable: "Home unavailable",
        homeHeroSubtitle: "Follow the Camino with official routes, check-ins and pilgrim groups in one bright, social experience.",
        officialRoutesLabel: "Official routes",
        checkInsLabel: "Check-ins",
        manualLabel: "Manual",
        quickActionsTitle: "Quick actions",
        exploreRoutesTitle: "Explore official routes",
        exploreRoutesSubtitle: "Jump into the Camino catalog and compare the mood of each route.",
        groupsSoonTitle: "Pilgrim groups are next",
        groupsSoonSubtitle: "The social layer is ready for routes, companions and future profile motion.",
        featuredRoutesTitle: "Featured routes",
        seeAll: "See all",
        routesCountValue: "10",
        featuredFrancesSubtitle: "The most iconic route into Santiago.",
        featuredNorteSubtitle: "Atlantic energy and rugged coastline.",
        routesLoading: "Loading routes",
        routesTitle: "Browse routes",
        routesSubtitle: "Compare official Camino routes and open each one with a cleaner, more editorial view.",
        sourceTitle: "Source",
        sourceValue: "Official",
        layersTitle: "Layers",
        layersValue: "Stages",
        routeLoading: "Loading route",
        routeUnavailable: "Route unavailable",
        routeNavigationTitle: "Route",
        originTitle: "Origin",
        routeCharacterTitle: "Route character",
        whyItMattersTitle: "Why it matters",
        routeMapTitle: "Route map",
        stopsLabel: "stops",
        routeMapUnavailableTitle: "Map unavailable",
        routeMapUnavailableMessage: "We could not resolve the stage stops for this route.",
        stagesTitle: "Stages",
        walkingStageLabel: "Walking stage",
        maritimeSegmentLabel: "Maritime segment",
        stageStopLabel: "Stage stop",
        settingsTitle: "Settings",
        settingsSubtitle: "Personalize the app language and the visual theme you want to use while planning your Camino.",
        languageSectionTitle: "Language",
        languageSectionSubtitle: "Switch the app copy instantly without leaving the experience.",
        appearanceSectionTitle: "Appearance",
        appearanceSectionSubtitle: "Choose between light, dark or the system look for the whole app shell.",
        previewSectionTitle: "Live preview",
        previewTitle: "Your Camino, your way",
        previewSubtitle: "Settings now drive app language and appearance across Home, Routes and future social screens.",
        previewBadge: "Personalized",
        personalizedCopyTitle: "Localized copy foundation",
        personalizedCopySubtitle: "The feature is ready to keep extending translated content from one central place.",
        systemLabel: "System",
        englishLabel: "English",
        spanishLabel: "Spanish",
        frenchLabel: "French",
        lightLabel: "Light",
        darkLabel: "Dark"
    )

    static let spanish = AppStrings(
        language: .spanish,
        tabHome: "Inicio",
        tabRoutes: "Rutas",
        tabSettings: "Ajustes",
        homeLoading: "Cargando inicio",
        homeUnavailable: "Inicio no disponible",
        homeHeroSubtitle: "Sigue el Camino con rutas oficiales, check-ins y grupos de peregrinos en una experiencia visual y social.",
        officialRoutesLabel: "Rutas oficiales",
        checkInsLabel: "Check-ins",
        manualLabel: "Manual",
        quickActionsTitle: "Acciones rápidas",
        exploreRoutesTitle: "Explorar rutas oficiales",
        exploreRoutesSubtitle: "Entra en el catálogo del Camino y compara el carácter de cada ruta.",
        groupsSoonTitle: "Los grupos llegan pronto",
        groupsSoonSubtitle: "La capa social ya está lista para rutas, compañeros y futuras animaciones de perfil.",
        featuredRoutesTitle: "Rutas destacadas",
        seeAll: "Ver todas",
        routesCountValue: "10",
        featuredFrancesSubtitle: "La ruta más icónica hacia Santiago.",
        featuredNorteSubtitle: "Energía atlántica y costa salvaje.",
        routesLoading: "Cargando rutas",
        routesTitle: "Explorar rutas",
        routesSubtitle: "Compara las rutas oficiales del Camino y entra en cada una con una vista más clara y editorial.",
        sourceTitle: "Fuente",
        sourceValue: "Oficial",
        layersTitle: "Capas",
        layersValue: "Etapas",
        routeLoading: "Cargando ruta",
        routeUnavailable: "Ruta no disponible",
        routeNavigationTitle: "Ruta",
        originTitle: "Origen",
        routeCharacterTitle: "Carácter de la ruta",
        whyItMattersTitle: "Por qué importa",
        routeMapTitle: "Mapa de la ruta",
        stopsLabel: "paradas",
        routeMapUnavailableTitle: "Mapa no disponible",
        routeMapUnavailableMessage: "No hemos podido resolver las paradas de esta ruta.",
        stagesTitle: "Etapas",
        walkingStageLabel: "Etapa a pie",
        maritimeSegmentLabel: "Tramo marítimo",
        stageStopLabel: "Parada de etapa",
        settingsTitle: "Ajustes",
        settingsSubtitle: "Personaliza el idioma de la app y el tema visual que quieres usar mientras preparas tu Camino.",
        languageSectionTitle: "Idioma",
        languageSectionSubtitle: "Cambia el texto de la app al instante sin salir de la experiencia.",
        appearanceSectionTitle: "Apariencia",
        appearanceSectionSubtitle: "Elige entre claro, oscuro o sistema para toda la app.",
        previewSectionTitle: "Vista previa",
        previewTitle: "Tu Camino, a tu manera",
        previewSubtitle: "Los ajustes ya controlan el idioma y la apariencia en Inicio, Rutas y futuras pantallas sociales.",
        previewBadge: "Personalizado",
        personalizedCopyTitle: "Base de textos localizados",
        personalizedCopySubtitle: "La feature ya está preparada para seguir ampliando contenido traducido desde un punto central.",
        systemLabel: "Sistema",
        englishLabel: "Inglés",
        spanishLabel: "Español",
        frenchLabel: "Francés",
        lightLabel: "Claro",
        darkLabel: "Oscuro"
    )

    static let french = AppStrings(
        language: .french,
        tabHome: "Accueil",
        tabRoutes: "Routes",
        tabSettings: "Réglages",
        homeLoading: "Chargement de l'accueil",
        homeUnavailable: "Accueil indisponible",
        homeHeroSubtitle: "Suivez le Camino avec des itinéraires officiels, des check-ins et des groupes de pèlerins dans une expérience lumineuse et sociale.",
        officialRoutesLabel: "Routes officielles",
        checkInsLabel: "Check-ins",
        manualLabel: "Manuel",
        quickActionsTitle: "Actions rapides",
        exploreRoutesTitle: "Explorer les routes officielles",
        exploreRoutesSubtitle: "Entrez dans le catalogue du Camino et comparez le caractère de chaque route.",
        groupsSoonTitle: "Les groupes arrivent bientôt",
        groupsSoonSubtitle: "La couche sociale est prête pour les routes, les compagnons et les futures animations de profil.",
        featuredRoutesTitle: "Routes en vedette",
        seeAll: "Voir tout",
        routesCountValue: "10",
        featuredFrancesSubtitle: "La route la plus emblématique vers Saint-Jacques.",
        featuredNorteSubtitle: "Énergie atlantique et côte sauvage.",
        routesLoading: "Chargement des routes",
        routesTitle: "Explorer les routes",
        routesSubtitle: "Comparez les routes officielles du Camino et ouvrez chacune avec une vue plus claire et éditoriale.",
        sourceTitle: "Source",
        sourceValue: "Officielle",
        layersTitle: "Couches",
        layersValue: "Étapes",
        routeLoading: "Chargement de la route",
        routeUnavailable: "Route indisponible",
        routeNavigationTitle: "Route",
        originTitle: "Origine",
        routeCharacterTitle: "Caractère de la route",
        whyItMattersTitle: "Pourquoi c'est important",
        routeMapTitle: "Carte de la route",
        stopsLabel: "arrêts",
        routeMapUnavailableTitle: "Carte indisponible",
        routeMapUnavailableMessage: "Nous n'avons pas pu résoudre les arrêts de cette route.",
        stagesTitle: "Étapes",
        walkingStageLabel: "Étape à pied",
        maritimeSegmentLabel: "Segment maritime",
        stageStopLabel: "Arrêt d'étape",
        settingsTitle: "Réglages",
        settingsSubtitle: "Personnalisez la langue de l'app et le thème visuel à utiliser pendant la préparation de votre Camino.",
        languageSectionTitle: "Langue",
        languageSectionSubtitle: "Changez instantanément les textes de l'app sans quitter l'expérience.",
        appearanceSectionTitle: "Apparence",
        appearanceSectionSubtitle: "Choisissez entre clair, sombre ou système pour toute l'application.",
        previewSectionTitle: "Aperçu",
        previewTitle: "Votre Camino, à votre façon",
        previewSubtitle: "Les réglages contrôlent déjà la langue et l'apparence dans Accueil, Routes et les futurs écrans sociaux.",
        previewBadge: "Personnalisé",
        personalizedCopyTitle: "Base de textes localisés",
        personalizedCopySubtitle: "La fonctionnalité est prête à continuer d'étendre le contenu traduit depuis un point central.",
        systemLabel: "Système",
        englishLabel: "Anglais",
        spanishLabel: "Espagnol",
        frenchLabel: "Français",
        lightLabel: "Clair",
        darkLabel: "Sombre"
    )
}

private struct AppStringsKey: EnvironmentKey {
    static let defaultValue = AppStrings.english
}

extension EnvironmentValues {
    var appStrings: AppStrings {
        get { self[AppStringsKey.self] }
        set { self[AppStringsKey.self] = newValue }
    }
}
