import SwiftUI

struct AppStrings {
    let language: AppLanguage

    let tabHome: String
    let tabRoutes: String
    let tabProfile: String
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

    let profileTitle: String
    let profileSubtitle: String
    let profileJourneySectionTitle: String
    let profileBioSectionTitle: String
    let profileBioPlaceholder: String
    let profileRouteLabel: String
    let profileStageLabel: String
    let profileCityLabel: String
    let profilePhoneLabel: String
    let profileActionsSectionTitle: String
    let profileActionsSectionSubtitle: String
    let profileEditActionTitle: String
    let profileEditActionSubtitle: String
    let profileSettingsActionTitle: String
    let profileSettingsActionSubtitle: String

    let editProfileTitle: String
    let editProfileSubtitle: String
    let editIdentitySectionTitle: String
    let editJourneySectionTitle: String
    let editBioSectionTitle: String
    let editNameLabel: String
    let editPhoneLabel: String
    let editCityLabel: String
    let editBioLabel: String
    let editAvatarLabel: String
    let editAvatarActionTitle: String
    let editRouteLabel: String
    let editStageLabel: String
    let removePhotoLabel: String
    let photoPickerCancelledMessage: String
    let photoPickerErrorMessage: String
    let saveLabel: String

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

    func stageValue(_ number: Int) -> String {
        switch language {
        case .spanish:
            "Etapa \(number)"
        case .french:
            "Étape \(number)"
        case .english, .system:
            "Stage \(number)"
        }
    }
}

extension AppStrings {
    static let english = AppStrings(
        language: .english,
        tabHome: "Home",
        tabRoutes: "Routes",
        tabProfile: "Profile",
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
        profileTitle: "Profile",
        profileSubtitle: "Keep your pilgrim identity, route and current stage ready for the social layer.",
        profileJourneySectionTitle: "Current journey",
        profileBioSectionTitle: "Bio",
        profileBioPlaceholder: "Add a short note about your Camino.",
        profileRouteLabel: "Current route",
        profileStageLabel: "Current stage",
        profileCityLabel: "Current city",
        profilePhoneLabel: "Phone",
        profileActionsSectionTitle: "Account",
        profileActionsSectionSubtitle: "Manage the local pilgrim card and your app preferences.",
        profileEditActionTitle: "Edit profile",
        profileEditActionSubtitle: "Update your name, city, route, stage and pilgrim bio.",
        profileSettingsActionTitle: "App settings",
        profileSettingsActionSubtitle: "Control language and appearance from the same profile flow.",
        editProfileTitle: "Edit profile",
        editProfileSubtitle: "Adjust the local identity you want to show inside WeCamino.",
        editIdentitySectionTitle: "Identity",
        editJourneySectionTitle: "Journey status",
        editBioSectionTitle: "Pilgrim note",
        editNameLabel: "Name",
        editPhoneLabel: "Phone number",
        editCityLabel: "City",
        editBioLabel: "Bio",
        editAvatarLabel: "Profile photo",
        editAvatarActionTitle: "Choose from library",
        editRouteLabel: "Current route",
        editStageLabel: "Current stage",
        removePhotoLabel: "Remove photo",
        photoPickerCancelledMessage: "No image was selected.",
        photoPickerErrorMessage: "We couldn't load that image. Try another one.",
        saveLabel: "Save",
        settingsTitle: "Settings",
        settingsSubtitle: "Personalize the app language and the visual theme you want to use while planning your Camino.",
        languageSectionTitle: "Language",
        languageSectionSubtitle: "Switch the app copy instantly without leaving the experience.",
        appearanceSectionTitle: "Appearance",
        appearanceSectionSubtitle: "Choose between light, dark or the system look for the whole app shell.",
        previewSectionTitle: "Live preview",
        previewTitle: "Your Camino, your way",
        previewSubtitle: "Settings now drive app language and appearance across Home, Routes and Profile.",
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
        tabProfile: "Perfil",
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
        profileTitle: "Perfil",
        profileSubtitle: "Mantén lista tu identidad de peregrino, tu ruta y tu etapa actual para la capa social.",
        profileJourneySectionTitle: "Camino actual",
        profileBioSectionTitle: "Bio",
        profileBioPlaceholder: "Añade una nota breve sobre tu Camino.",
        profileRouteLabel: "Ruta actual",
        profileStageLabel: "Etapa actual",
        profileCityLabel: "Ciudad actual",
        profilePhoneLabel: "Teléfono",
        profileActionsSectionTitle: "Cuenta",
        profileActionsSectionSubtitle: "Gestiona tu ficha local de peregrino y las preferencias de la app.",
        profileEditActionTitle: "Editar perfil",
        profileEditActionSubtitle: "Actualiza nombre, ciudad, ruta, etapa y tu bio de peregrino.",
        profileSettingsActionTitle: "Ajustes de la app",
        profileSettingsActionSubtitle: "Controla idioma y apariencia desde el mismo flujo del perfil.",
        editProfileTitle: "Editar perfil",
        editProfileSubtitle: "Ajusta la identidad local que quieres mostrar dentro de WeCamino.",
        editIdentitySectionTitle: "Identidad",
        editJourneySectionTitle: "Estado del camino",
        editBioSectionTitle: "Nota del peregrino",
        editNameLabel: "Nombre",
        editPhoneLabel: "Teléfono",
        editCityLabel: "Ciudad",
        editBioLabel: "Bio",
        editAvatarLabel: "Foto de perfil",
        editAvatarActionTitle: "Elegir de la galería",
        editRouteLabel: "Ruta actual",
        editStageLabel: "Etapa actual",
        removePhotoLabel: "Quitar foto",
        photoPickerCancelledMessage: "No se ha seleccionado ninguna imagen.",
        photoPickerErrorMessage: "No hemos podido cargar esa imagen. Prueba con otra.",
        saveLabel: "Guardar",
        settingsTitle: "Ajustes",
        settingsSubtitle: "Personaliza el idioma de la app y el tema visual que quieres usar mientras preparas tu Camino.",
        languageSectionTitle: "Idioma",
        languageSectionSubtitle: "Cambia el texto de la app al instante sin salir de la experiencia.",
        appearanceSectionTitle: "Apariencia",
        appearanceSectionSubtitle: "Elige entre claro, oscuro o sistema para toda la app.",
        previewSectionTitle: "Vista previa",
        previewTitle: "Tu Camino, a tu manera",
        previewSubtitle: "Los ajustes ya controlan el idioma y la apariencia en Inicio, Rutas y Perfil.",
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
        tabProfile: "Profil",
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
        whyItMattersTitle: "Pourquoi elle compte",
        routeMapTitle: "Carte de la route",
        stopsLabel: "arrêts",
        routeMapUnavailableTitle: "Carte indisponible",
        routeMapUnavailableMessage: "Impossible de résoudre les arrêts de cette route.",
        stagesTitle: "Étapes",
        walkingStageLabel: "Étape à pied",
        maritimeSegmentLabel: "Segment maritime",
        stageStopLabel: "Arrêt d'étape",
        profileTitle: "Profil",
        profileSubtitle: "Gardez prête votre identité de pèlerin, votre route et votre étape actuelle pour la couche sociale.",
        profileJourneySectionTitle: "Chemin actuel",
        profileBioSectionTitle: "Bio",
        profileBioPlaceholder: "Ajoutez une courte note sur votre Camino.",
        profileRouteLabel: "Route actuelle",
        profileStageLabel: "Étape actuelle",
        profileCityLabel: "Ville actuelle",
        profilePhoneLabel: "Téléphone",
        profileActionsSectionTitle: "Compte",
        profileActionsSectionSubtitle: "Gérez votre fiche locale de pèlerin et les préférences de l'app.",
        profileEditActionTitle: "Modifier le profil",
        profileEditActionSubtitle: "Mettez à jour le nom, la ville, la route, l'étape et la bio.",
        profileSettingsActionTitle: "Réglages de l'app",
        profileSettingsActionSubtitle: "Contrôlez la langue et l'apparence depuis le même flux de profil.",
        editProfileTitle: "Modifier le profil",
        editProfileSubtitle: "Ajustez l'identité locale que vous voulez montrer dans WeCamino.",
        editIdentitySectionTitle: "Identité",
        editJourneySectionTitle: "Statut du chemin",
        editBioSectionTitle: "Note du pèlerin",
        editNameLabel: "Nom",
        editPhoneLabel: "Téléphone",
        editCityLabel: "Ville",
        editBioLabel: "Bio",
        editAvatarLabel: "Photo de profil",
        editAvatarActionTitle: "Choisir dans la photothèque",
        editRouteLabel: "Route actuelle",
        editStageLabel: "Étape actuelle",
        removePhotoLabel: "Supprimer la photo",
        photoPickerCancelledMessage: "Aucune image n'a été sélectionnée.",
        photoPickerErrorMessage: "Impossible de charger cette image. Essayez-en une autre.",
        saveLabel: "Enregistrer",
        settingsTitle: "Réglages",
        settingsSubtitle: "Personnalisez la langue de l'app et le thème visuel utilisé pendant la préparation du Camino.",
        languageSectionTitle: "Langue",
        languageSectionSubtitle: "Changez le texte de l'app instantanément sans quitter l'expérience.",
        appearanceSectionTitle: "Apparence",
        appearanceSectionSubtitle: "Choisissez clair, sombre ou système pour toute l'app.",
        previewSectionTitle: "Aperçu",
        previewTitle: "Votre Camino, à votre façon",
        previewSubtitle: "Les réglages contrôlent déjà la langue et l'apparence dans Accueil, Routes et Profil.",
        previewBadge: "Personnalisé",
        personalizedCopyTitle: "Base de textes localisés",
        personalizedCopySubtitle: "La feature est prête à étendre le contenu traduit depuis un point central.",
        systemLabel: "Système",
        englishLabel: "Anglais",
        spanishLabel: "Espagnol",
        frenchLabel: "Français",
        lightLabel: "Clair",
        darkLabel: "Sombre"
    )
}

extension AppStrings {
    var tabFriends: String {
        switch language {
        case .spanish:
            "Amigos"
        case .french:
            "Amis"
        case .english, .system:
            "Friends"
        }
    }

    var friendsTitle: String {
        switch language {
        case .spanish:
            "Amigos"
        case .french:
            "Amis"
        case .english, .system:
            "Friends"
        }
    }

    var friendsSubtitle: String {
        switch language {
        case .spanish:
            "Gestiona tu círculo del Camino con solicitudes recibidas, peticiones enviadas y amigos ya aceptados."
        case .french:
            "Gérez votre cercle du Camino avec les demandes reçues, envoyées et les amis déjà acceptés."
        case .english, .system:
            "Manage your Camino circle with incoming requests, sent invitations and accepted friends."
        }
    }

    var friendsCountTitle: String {
        switch language {
        case .spanish:
            "Amigos"
        case .french:
            "Amis"
        case .english, .system:
            "Friends"
        }
    }

    var requestsCountTitle: String {
        switch language {
        case .spanish:
            "Recibidas"
        case .french:
            "Reçues"
        case .english, .system:
            "Incoming"
        }
    }

    var sentCountTitle: String {
        switch language {
        case .spanish:
            "Enviadas"
        case .french:
            "Envoyées"
        case .english, .system:
            "Sent"
        }
    }

    var friendsSegmentFriends: String {
        switch language {
        case .spanish:
            "Amigos"
        case .french:
            "Amis"
        case .english, .system:
            "Friends"
        }
    }

    var friendsSegmentRequests: String {
        switch language {
        case .spanish:
            "Solicitudes"
        case .french:
            "Demandes"
        case .english, .system:
            "Requests"
        }
    }

    var friendsSegmentDiscover: String {
        switch language {
        case .spanish:
            "Descubrir"
        case .french:
            "Découvrir"
        case .english, .system:
            "Discover"
        }
    }

    var friendsListTitle: String {
        switch language {
        case .spanish:
            "Tu círculo"
        case .french:
            "Votre cercle"
        case .english, .system:
            "Your circle"
        }
    }

    var friendsListSubtitle: String {
        switch language {
        case .spanish:
            "Peregrinos que ya forman parte de tu red y que verás más adelante en el timeline social."
        case .french:
            "Pèlerins déjà dans votre réseau et que vous verrez plus tard dans la timeline sociale."
        case .english, .system:
            "Pilgrims already in your network and ready for the future social timeline."
        }
    }

    var requestsListTitle: String {
        switch language {
        case .spanish:
            "Gestionar solicitudes"
        case .french:
            "Gérer les demandes"
        case .english, .system:
            "Manage requests"
        }
    }

    var requestsListSubtitle: String {
        switch language {
        case .spanish:
            "Mismo flujo base que en Instagram: recibes, aceptas o rechazas; cuando envías, puedes cancelar."
        case .french:
            "Même logique de base qu'Instagram : vous recevez, acceptez ou refusez ; si vous envoyez, vous pouvez annuler."
        case .english, .system:
            "The same core Instagram-style flow: receive, accept or decline; when you send, you can still cancel."
        }
    }

    var discoverListTitle: String {
        switch language {
        case .spanish:
            "Descubrir peregrinos"
        case .french:
            "Découvrir des pèlerins"
        case .english, .system:
            "Discover pilgrims"
        }
    }

    var discoverListSubtitle: String {
        switch language {
        case .spanish:
            "Explora posibles compañeros de Camino y envía una solicitud de amistad en un toque."
        case .french:
            "Explorez de nouveaux compagnons de Camino et envoyez une demande d'amitié en un geste."
        case .english, .system:
            "Explore potential Camino companions and send a friendship request in one tap."
        }
    }

    var incomingRequestsTitle: String {
        switch language {
        case .spanish:
            "Solicitudes recibidas"
        case .french:
            "Demandes reçues"
        case .english, .system:
            "Incoming requests"
        }
    }

    var outgoingRequestsTitle: String {
        switch language {
        case .spanish:
            "Solicitudes enviadas"
        case .french:
            "Demandes envoyées"
        case .english, .system:
            "Sent requests"
        }
    }

    var friendsEmptyTitle: String {
        switch language {
        case .spanish:
            "Todavía no tienes amigos"
        case .french:
            "Vous n'avez pas encore d'amis"
        case .english, .system:
            "No friends yet"
        }
    }

    var friendsEmptySubtitle: String {
        switch language {
        case .spanish:
            "Cuando aceptes o te acepten una solicitud, tu red aparecerá aquí."
        case .french:
            "Quand une demande sera acceptée, votre réseau apparaîtra ici."
        case .english, .system:
            "Once a request is accepted, your Camino network will appear here."
        }
    }

    var requestsEmptyTitle: String {
        switch language {
        case .spanish:
            "No hay solicitudes pendientes"
        case .french:
            "Aucune demande en attente"
        case .english, .system:
            "No pending requests"
        }
    }

    var requestsEmptySubtitle: String {
        switch language {
        case .spanish:
            "Ahora mismo no tienes nada que revisar ni ninguna invitación enviada esperando respuesta."
        case .french:
            "Vous n'avez rien à revoir ni aucune invitation envoyée en attente de réponse."
        case .english, .system:
            "There is nothing to review right now and no sent invitation still waiting for an answer."
        }
    }

    var discoverEmptyTitle: String {
        switch language {
        case .spanish:
            "No quedan sugerencias"
        case .french:
            "Plus aucune suggestion"
        case .english, .system:
            "No more suggestions"
        }
    }

    var discoverEmptySubtitle: String {
        switch language {
        case .spanish:
            "Ya has revisado a todos los peregrinos disponibles para esta demo local."
        case .french:
            "Vous avez déjà parcouru tous les pèlerins disponibles dans cette démo locale."
        case .english, .system:
            "You already reviewed every pilgrim available in this local demo."
        }
    }

    var friendAddAction: String {
        switch language {
        case .spanish:
            "Añadir"
        case .french:
            "Ajouter"
        case .english, .system:
            "Add"
        }
    }

    var friendAcceptAction: String {
        switch language {
        case .spanish:
            "Aceptar"
        case .french:
            "Accepter"
        case .english, .system:
            "Accept"
        }
    }

    var friendDeclineAction: String {
        switch language {
        case .spanish:
            "Rechazar"
        case .french:
            "Refuser"
        case .english, .system:
            "Decline"
        }
    }

    var friendCancelAction: String {
        switch language {
        case .spanish:
            "Cancelar"
        case .french:
            "Annuler"
        case .english, .system:
            "Cancel"
        }
    }

    var friendRemoveAction: String {
        switch language {
        case .spanish:
            "Eliminar amistad"
        case .french:
            "Retirer l'ami"
        case .english, .system:
            "Remove friend"
        }
    }

    func friendRemoveConfirmationTitle(_ name: String) -> String {
        switch language {
        case .spanish:
            "Eliminar a \(name)"
        case .french:
            "Retirer \(name)"
        case .english, .system:
            "Remove \(name)"
        }
    }

    func friendRemoveConfirmationMessage(_ name: String) -> String {
        switch language {
        case .spanish:
            "Se eliminará a \(name) de tu lista de amigos. Podrás volver a enviar una solicitud más adelante."
        case .french:
            "\(name) sera retire de votre liste d'amis. Vous pourrez envoyer une nouvelle demande plus tard."
        case .english, .system:
            "\(name) will be removed from your friends list. You can send a new request later."
        }
    }

    var friendPendingLabel: String {
        switch language {
        case .spanish:
            "Enviada"
        case .french:
            "Envoyée"
        case .english, .system:
            "Sent"
        }
    }

    var friendConnectedLabel: String {
        switch language {
        case .spanish:
            "Amigos"
        case .french:
            "Amis"
        case .english, .system:
            "Friends"
        }
    }

    var friendDetailRouteTitle: String {
        switch language {
        case .spanish:
            "Camino"
        case .french:
            "Chemin"
        case .english, .system:
            "Route"
        }
    }

    var friendDetailStageTitle: String {
        switch language {
        case .spanish:
            "Etapa"
        case .french:
            "Etape"
        case .english, .system:
            "Stage"
        }
    }

    var friendDetailLocationTitle: String {
        switch language {
        case .spanish:
            "Ubicacion"
        case .french:
            "Position"
        case .english, .system:
            "Location"
        }
    }

    var friendDetailBioTitle: String {
        switch language {
        case .spanish:
            "Bio"
        case .french:
            "Bio"
        case .english, .system:
            "Bio"
        }
    }

    var notificationsTitle: String {
        switch language {
        case .spanish:
            "Notificaciones"
        case .french:
            "Notifications"
        case .english, .system:
            "Notifications"
        }
    }

    var notificationsSubtitle: String {
        switch language {
        case .spanish:
            "Aquí aparecen las peticiones de amistad pendientes para que puedas aceptarlas o rechazarlas."
        case .french:
            "Les demandes d'amitié en attente apparaissent ici pour être acceptées ou refusées."
        case .english, .system:
            "Pending friendship requests appear here so you can accept or decline them."
        }
    }

    var notificationsEmptyTitle: String {
        switch language {
        case .spanish:
            "No tienes notificaciones pendientes"
        case .french:
            "Aucune notification en attente"
        case .english, .system:
            "No pending notifications"
        }
    }

    var notificationsEmptySubtitle: String {
        switch language {
        case .spanish:
            "Cuando alguien te envíe una solicitud de amistad, la verás aquí y la campanita mostrará el contador."
        case .french:
            "Quand quelqu'un vous enverra une demande d'amitié, elle apparaîtra ici et la cloche affichera le compteur."
        case .english, .system:
            "When someone sends you a friendship request, it will appear here and the bell will show the badge."
        }
    }

    func friendRequestNotificationTitle(_ name: String) -> String {
        switch language {
        case .spanish:
            "\(name) quiere ser tu amigo"
        case .french:
            "\(name) veut devenir votre ami"
        case .english, .system:
            "\(name) wants to be your friend"
        }
    }

    func friendRequestNotificationMessage(route: String, city: String, stage: String) -> String {
        switch language {
        case .spanish:
            "\(route) · \(city) · \(stage)"
        case .french:
            "\(route) · \(city) · \(stage)"
        case .english, .system:
            "\(route) · \(city) · \(stage)"
        }
    }
}

private struct AppStringsEnvironmentKey: EnvironmentKey {
    static let defaultValue = AppStrings.english
}

extension EnvironmentValues {
    var appStrings: AppStrings {
        get { self[AppStringsEnvironmentKey.self] }
        set { self[AppStringsEnvironmentKey.self] = newValue }
    }
}
