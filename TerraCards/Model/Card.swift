//
//  Card.swift
//  TerraCards
//
//  Created by Joséphine Delobel on 07/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import Foundation
import MapKit
import SwiftUI

final class Card: Decodable, Identifiable, Hashable, ObservableObject {
    let id = UUID()
    let name: String!
    
    var imageRectoURL: URL?
    var imageRectoOnlineDate: Date?
    
    var imageVersoURL: URL?
    var imageVersoOnlineDate: Date?
    
    let habitats: [HabitatType]!
    let season: String!
    let averageSize: String!
    let anecdote: String!
    var obtained: Bool
    let collection : CollectionType!
    let alert: AlertType!
    
    
    var latitude: Double
    var longitude: Double
    
    var coordinates: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: 100, longitudinalMeters: 100)
    }
    
    @Published var imageRecto: Image?
    @Published var imageVerso: Image?
    
    // Pour rendre la Card Decodable du JSON
    enum CodingKeys: String, CodingKey {
        case id, name, imageRecto, imageVerso, habitats, season, averageSize, anecdote, collection, alert, latitude, longitude, obtained, imageRectoLastChange, imageVersoLastChange
    }
    
    
    // Pour pouvoir parcourir un tableau de Card avec ForEach
    static func == (lhs: Card, rhs: Card) -> Bool {
           return lhs.id == rhs.id
       }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    

    // Initialisation à vide (pour les preview)
    init() {
        self.name = "Chêne"
        self.imageRectoURL = URL(string: "https://master.salamandre.net/media/21902/chene-jardin-1800x1012.png")!
        self.imageVersoURL = self.imageRectoURL
        self.habitats = [.mountains]
        self.alert = .blackAlert
        self.collection = .amphibian
        self.obtained = false
        self.anecdote = "hahaha"
        self.averageSize = "telle taille"
        self.latitude = 48
        self.longitude = 2
        self.season = "hiver"
    }
    
    // Initialisation depuis un decoder JSON
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: CodingKeys.name)
        habitats = try? values.decode([HabitatType].self, forKey: CodingKeys.habitats)
        season = try? values.decode(String.self, forKey: CodingKeys.season)
        averageSize = try? values.decode(String.self, forKey: CodingKeys.averageSize)
        anecdote = try? values.decode(String.self, forKey: CodingKeys.anecdote)
        collection = try? values.decode(CollectionType.self, forKey: CodingKeys.collection)
        alert = try? values.decode(AlertType.self, forKey: CodingKeys.alert)
        if let longitude = try?  values.decode(Double.self, forKey: CodingKeys.longitude) {
            self.longitude = longitude
        } else {
            self.longitude = 48
        }
        if let latitude = try?  values.decode(Double.self, forKey: CodingKeys.latitude) {
            self.latitude = latitude
        } else {
            self.latitude = 2
        }
        if let obtained = try?  values.decode(Bool.self, forKey: CodingKeys.obtained) {
            self.obtained = obtained
        } else {
            self.obtained = false
        }
        
        if let imageRectoLastChange = try? values.decode(String.self, forKey: CodingKeys.imageRectoLastChange) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            self.imageRectoOnlineDate = formatter.date(from: imageRectoLastChange)

        } else {
            self.imageRectoOnlineDate = nil
        }
        
        if let imageVersoLastChange = try? values.decode(String.self, forKey: CodingKeys.imageVersoLastChange) {
            let formatter = DateFormatter()
            self.imageVersoOnlineDate = formatter.date(from: imageVersoLastChange)
        } else {
            self.imageVersoOnlineDate = nil
        }
        
        
        if let imageRectoArray = try? values.decode([ImageJson].self, forKey: CodingKeys.imageRecto) {
            self.imageRectoURL = URL(string: imageRectoArray[0].url)!
            //self.imageRecto?.isFileURL

        }
        
        if let imageVersoArray = try? values.decode([ImageJson].self, forKey: CodingKeys.imageVerso) {
            self.imageVersoURL = URL(string: imageVersoArray[0].url)!

        }
        
        imageRecto = nil
        imageVerso = nil
        
    }

    
    
    
    // Télécharger les images, depuis le HTTP ou depuis le Cache
    func loadingImages() {
        
        if imageRectoOnlineDate == nil ||
            imageRectoOnlineDate! < (FileProvider.fileModificationDate(fileURL: FileProvider.getCachedCardImageUrl(name: self.name, suffix: "recto")) ?? Date())  {
            print("cache cachou")
            imageRecto = FileProvider.getImageFromCache(name: self.name, suffix: "recto")
        }
        if imageVersoOnlineDate == nil ||
            imageVersoOnlineDate! < (FileProvider.fileModificationDate(fileURL: FileProvider.getCachedCardImageUrl(name: self.name, suffix: "verso")) ?? Date()) {
            imageVerso = FileProvider.getImageFromCache(name: self.name, suffix: "verso")
        }


        if imageRecto == nil && imageRectoURL != nil {
            print("on télécharge")
            APIProvider.shared.downloadImageFromURL(url: imageRectoURL!, completion: { response in
                switch response {
                case let .success(response):
                    switch response {
                    case let .image(image: image):
                        self.imageRecto = Image(uiImage: image)
                        FileProvider.writeImageInCache(image: image, name: self.name, suffix: "recto")
                    default:
                        print("on a téléchargé autre chose qu'une image")
                    }
                case let .failure(error):
                    print("on a téléchargé et on a échoué : \(error)")
                }

            })
        }
        
        if imageVerso == nil && imageVersoURL != nil {
            APIProvider.shared.downloadImageFromURL(url: imageVersoURL!, completion: { response in
                switch response {
                case let .success(response):
                    switch response {
                    case let .image(image: image):
                        self.imageVerso = Image(uiImage: image)
                        FileProvider.writeImageInCache(image: image, name: self.name, suffix: "verso")
                    default:
                        print("on a téléchargé autre chose qu'une image")
                    }
                case let .failure(error):
                    print("on a téléchargé et on a échoué : \(error)")
                }
            })
        }
    }
}

// Enums

enum HabitatType: String, Codable {
    case sea, mountains, city, countryside, forest
    var name : String {
        get {
            switch self {
            case .sea : return "Mer"
            case .mountains : return "Montagne"
            case .city : return "Ville"
            case .countryside : return "Campagne"
            case .forest : return "Forêt"
                
            }
        }
    }
}


enum CollectionType: String, CaseIterable, Identifiable, Codable{
    case tree, fish, mollusc, largeMammal, bird, insect, reptile, plant, amphibian, smallMammal, spider, dinosaur
    
    var id : UUID {
        return UUID()
    }
    
    var index : Int {
        get {
            switch self {
                case .tree : return 0
                case .fish : return 1
                case .mollusc : return 2
                case .largeMammal : return 3
                case .bird : return 4
                case .insect : return 5
                case .reptile : return 6
                case .plant : return 7
                case .amphibian : return 8
                case .smallMammal : return 9
                case .spider : return 10
                case .dinosaur : return 11
            }
        }
    }
    
    var name : String {
        get {
            switch self {

                case .tree : return "Arbres"
                case .fish : return "Poissons"
                case .mollusc : return "Mollusques"
                case .largeMammal : return "Mammifères"
                case .bird : return "Oiseaux"
                case .insect : return "Insectes"
                case .reptile : return "Reptiles"
                case .plant : return "Plantes"
                case .amphibian : return "Amphibiens"
                case .smallMammal : return "Petits Mammifères"
                case .spider : return "Arachnides"
                case .dinosaur : return "Dinosaures"
            }
        }
    }
    
    var image : String {
        get {
            switch self {
                case .tree : return "arbre"
                case .fish : return "lotte"
                case .mollusc : return "grenouille"
                case .largeMammal : return "chat"
                case .bird : return "mesange"
                case .insect : return "abeille charpentiere"
                case .reptile : return "grenouille"
                case .plant : return "plantes"
                case .amphibian : return "grenouille"
                case .smallMammal : return "grenouille"
                case .spider : return "grenouille"
                case .dinosaur : return "grenouille"
            }
        }
    }
    
}

enum AlertType: String, Codable {
    case greenAlert, yellowAlert, redAlert, blackAlert
    var name : String {
        get {
            switch self {
            case .greenAlert : return "Vert"
            case .yellowAlert : return "Jaune"
            case .redAlert : return "Rouge"
            case .blackAlert : return "Noir"
            }
        }
    }
}
