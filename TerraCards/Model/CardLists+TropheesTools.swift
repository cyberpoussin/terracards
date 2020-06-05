//
//  CardStore.swift
//  TerraCards
//
//  Created by MacBookGP on 12/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    
    static let offwhite = Color(red: 225/255, green: 225/255, blue: 235/255)
    static let lightStart = Color(red: 60/255, green: 160/255, blue: 240/255)
    static let lightEnd = Color(red: 30/255, green: 80/255, blue: 120/255)
    static let gold = Color(red: 255/255, green: 215/255, blue: 0/255)
    static let silver = Color(red: 206/255, green: 206/255, blue: 206/255)
    static let bronze = Color(red: 97/255, green: 78/255, blue: 26/255)
    static let colorTrophees = Color("trophees")
}


// liste de toute les cartes
class CardStore : ObservableObject {
     
    @Published var allCards: [Card] = [
        Card()
    ]
}

extension CardsLists {
    
    /*
      fonction qui calcule le nombre total de carte + ceux obtenue et le nb de prorata pour l'evolutionBar
     */
    func numbersMaxObtainedCards() -> (nbCardMax :Int, nbCardObtained : Int , nbCardEvoltionBar: CGFloat) {
        var numberMax = 0
        var numberObtained = 0
        var numberCardEvolutionBar:CGFloat = 0.0
        
        allCards.forEach { card in
            numberMax += 1
        }
        wonCards.forEach { card in
             numberObtained += 1
        }
        
        // test si il n'y a pas de division par 0
        if numberMax == 0 && numberObtained == 0 {
            numberCardEvolutionBar = 0
        } else {
            numberCardEvolutionBar = CGFloat(170.0*(CGFloat(numberObtained) / CGFloat(numberMax)) )
        }
       
 
        print("-- cartes total  : \(numberMax)")
        print("-- cartes obtenus  : \(numberObtained)")
        print("-- nombre de l'evolutionBar  : \(numberCardEvolutionBar)")
        
        return (numberMax,numberObtained,numberCardEvolutionBar)
     }
    
    
    /*
     fonction qui calcule le nombre de carte total obtenue
     */
    func cardsObtained() -> Int {
       var number = 0
       wonCards.forEach { card in
            number += 1
       }
        print("------------ cartes obtenue  : \(number)")
       return number
    }
    
    /*
     retourne la couleur pour le contour de la carte trophee de toute les cartes
     */
    func numbersColorCards() -> Color {
        var numberMax = 0
        var numberObtained = 0
        var colorCardTrophee = Color.clear
        allCards.forEach { card in
            numberMax += 1
        }
        
        wonCards.forEach { card in
            numberObtained += 1
        }
                
        if numberMax == numberObtained {
            if numberObtained == 0 {
                colorCardTrophee = Color.clear
            } else {
                colorCardTrophee = Color.gold
            }
        } else if (numberObtained > 0 && CGFloat(numberObtained) < (CGFloat(4.0/5.0) * CGFloat(numberMax))) {   // condition entre carte min et max
            colorCardTrophee = Color.green  // couleur black si carte obtenue > 1
        } else if CGFloat(numberObtained) >= (CGFloat(4.0/5.0) * CGFloat(numberMax)) {
            colorCardTrophee = Color.orange // couleur green si carte > 4/5 des carte max
        } else {
            colorCardTrophee = Color.clear
        } // couleur gray si pas de carte obtenue
   
        
        
        print("--- number total max:  \(numberMax) number obtained : \(numberObtained)  color of card : \(colorCardTrophee)")
        
        return colorCardTrophee
    }
    
    /*
     calcule du nombre de carte max et obtenue ainsi que la couleur pour le contour de la carte trophee
     */
    func numberCardsMaxCollection(collection: CollectionType) -> (obtained:Int, collectionMax: Int, cardColor: Color, numberEvolutionBar: CGFloat) {
        
        let valeurMax = 170
        var numbersObtainedCollection = 0
        var numbersMaxCollection = 0
        var colorCardTrophee = Color.gray
        var numberProrataEvolutionBar:CGFloat = 0.0  // nombre du prorata pour affichage de l'evolution de la bar par rapport au max de carte et ceux obtenue
        
        allCards.forEach { card in
            if card.collection == collection {
                numbersMaxCollection += 1
            }
        }
        
        wonCards.forEach { card in
            if card.collection == collection {
                numbersObtainedCollection += 1
            }
        }
        
        if numbersMaxCollection == numbersObtainedCollection {
            if numbersObtainedCollection == 0 {
                colorCardTrophee = Color.clear
            } else {
                colorCardTrophee = Color.gold
            }
        } else if (numbersObtainedCollection > 0 && CGFloat(numbersObtainedCollection) < CGFloat(CGFloat(4.0/5.0) * CGFloat(numbersMaxCollection))) {   // condition entre carte min et max
            colorCardTrophee = Color.green  // couleur black si carte obtenue > 1
        } else if CGFloat(numbersObtainedCollection) >= CGFloat(4.0/5.0) * CGFloat(numbersMaxCollection) {
            colorCardTrophee = Color.orange // couleur green si carte > 4/5 des carte max
        } else {
            colorCardTrophee = Color.clear
        } // couleur gray si pas de carte obtenue
        
        
        // test si il n'y a pas de division par 0
        if numbersObtainedCollection == 0 && numbersMaxCollection == 0 {
            numberProrataEvolutionBar = 0.0
        } else {
            numberProrataEvolutionBar = CGFloat( valeurMax / numbersMaxCollection * numbersObtainedCollection)
        }

        print("-- cartes total  : \(numbersMaxCollection)")
        print("-- cartes obtenus  : \(numbersObtainedCollection)")
        print("-- nombre de l'evolutionBar  : \(numberProrataEvolutionBar)")
              
        return (numbersObtainedCollection, numbersMaxCollection, colorCardTrophee, numberProrataEvolutionBar)
    }
    
    func numberMaxCollection(collection: CollectionType) -> CGFloat {

        var numbersMaxCollection = 0
        
        allCards.forEach { card in
            if card.collection == collection {
                numbersMaxCollection += 1
            }
        }
         
        return CGFloat(numbersMaxCollection)
    }
    
    func numberObtainedCollection(collection: CollectionType) -> CGFloat {

        var numbersObtainedCollection = 0
        
        wonCards.forEach { card in
            if card.collection == collection {
                numbersObtainedCollection += 1
            }
        }
        return CGFloat(numbersObtainedCollection)
    }
}
 
