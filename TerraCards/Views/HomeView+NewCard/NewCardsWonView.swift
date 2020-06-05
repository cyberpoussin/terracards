//
//  NewCardsWonView.swift
//  TerraCards
//
//  Created by Joséphine Delobel on 20/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct NewCardsWonView: View {
    @EnvironmentObject var cardsModelView: CardsLists
    @State var randomCards: [Card] = []
    @State var allCardsWon = false
    var quizz = false
    var bgColor: Color
    var body: some View {
        
        ZStack {
            CollectionView(cardList: randomCards, bgColor: bgColor)
                .onAppear(){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.randomCards = self.cardsModelView.threeNewCardsOrLess()
                        if !self.randomCards.isEmpty {
                            self.cardsModelView.winCards(cards: self.randomCards)
                            
                            if self.quizz {
                                self.randomCards = self.randomCards + self.cardsModelView.threeNewCardsOrLess()
                                self.cardsModelView.winCards(cards: self.randomCards)
                                self.randomCards = self.randomCards + self.cardsModelView.threeNewCardsOrLess()
                                self.cardsModelView.winCards(cards: self.randomCards)
                            }
                            print("cartes hasard à afficher : \(self.randomCards)")
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            UserSettings.lastFreeWins = formatter.string(from: Date())
                            
                            print("gagné le \(UserSettings.lastFreeWins)")
                            print (self.cardsModelView.possibleToWinMoreForFree ? "il est possible de gagner + aujourd'hui" : "il n'est PAS possible de gagner + aujourd'hui")
                        } else {
                            self.allCardsWon = true
                        }
                        
                    })
            }
            
            if allCardsWon {
                VStack {
                    Text("Tu as déjà gagné toutes les cartes actuellement disponibles dans TerraCards. Tu peux relancer l'application régulièrement (en étant connecté à internet), de nouvelles cartes auront peut-être été ajoutées ! À bientôt. ")
                }
            }
        }
    }
}

struct NewCardsWonView_Previews: PreviewProvider {
    static var previews: some View {
        let env = CardsLists()
        return NewCardsWonView(bgColor: Color.yellow)
            .environmentObject(env)
            .onAppear(){
                env.fillLists(){response in
                    switch response {
                    case .success:
                        // ici ce sont les cartes qui étaient déjà dans les UserSettings
                        UserSettings.userCards = []
                        UserSettings.lastFreeWins = "2001-01-01"
                        print (env.possibleToWinMoreForFree ? "il est possible de gagner + aujourd'hui" : "il n'est PAS possible de gagner + aujourd'hui")
                        for card in env.wonCards {
                            print("carte de départ en preview : \(card.name ?? "")")
                        }
                        
                        
                        //                carte de départ en preview : Optional("Chêne")
                        //                carte de départ en preview : Optional("Dauphin")
                        //                carte de départ en preview : Optional("Ortie")
                        //                carte de départ en preview : Optional("Pavot cornu")
                        //                carte de départ en preview : Optional("Jacinthe des bois")
                        
                        // on en gagne quelques autres pour le fun, attention si le nom est pas le même exactement que dans la base : crash
                        var cardsToAdd: [Card] = []
                        cardsToAdd.append(env.allCards.first(where: {$0.name == "Mésange bleue"})!)
                        cardsToAdd.append(env.allCards.first(where: {$0.name == "Vipère aspic"})!)
                        env.winCards(cards: cardsToAdd)
                        
                        
                    case .failure :
                        print("mince")
                    }
                }
                
        }
        
    }
}
