//
//  TropheesView.swift
//  TerraCards
//
//  Created by Ghislain on 11/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct TropheesView: View {
    
    private let collection = CollectionType.allCases
    @EnvironmentObject var listeCards: CardsLists
    private let valeurMax:CGFloat = 170.0
    
    @State var accueil:Bool = false
    
    var body: some View {
        ZStack {
            Color.colorTrophees.opacity(0.1)
            .edgesIgnoringSafeArea(.all)

            ScrollView(.vertical, showsIndicators: false) {
                Spacer().frame(height: 30)
                HStack {   // carte total
                    CardTropheeView(image: "hat-school" , contour: listeCards.numbersColorCards())
                        
                    Spacer().frame(width: 30)

                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack(alignment: .bottom) {
                            Text("Gagnées : ")
                                .font(.callout)
                            Text("\(listeCards.numbersMaxObtainedCards().nbCardObtained) / \(listeCards.numbersMaxObtainedCards().nbCardMax)")
                            
                        }.foregroundColor(Color.gray)
                        EvolutionBar(valEvolutionBar: listeCards.numbersMaxObtainedCards().nbCardEvoltionBar, contour: listeCards.numbersColorCards())
                            .padding(.top, 8)
                    }.padding(.horizontal, 20)
                }
                
                ForEach(collection , id: \.id) { trophee in
                    // toute les autres cartes
                    HStack {
                        CardTropheeView(image: trophee.image, contour: self.listeCards.numberCardsMaxCollection(collection: trophee).cardColor)
                        Spacer().frame(width: 30)
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("\(trophee.name) : ")
                                    .font(.callout)
                                Text("\(self.listeCards.numberCardsMaxCollection(collection: trophee).obtained)")
                            }.foregroundColor(Color.gray)
                            EvolutionBar(valEvolutionBar: self.listeCards.numberCardsMaxCollection(collection: trophee).numberEvolutionBar, contour: self.listeCards.numberCardsMaxCollection(collection: trophee).cardColor)
                            .padding(.top, 8)
                        }.padding(.horizontal, 20)
                    }.padding(.vertical, 0)
                }
                Spacer().frame(height: 75)
            }
            
        }
    }
}



struct TropheesView_Previews: PreviewProvider {
    static var previews: some View {
        let env = CardsLists()
        return TropheesView()
            .environmentObject(env)
            .onAppear(){
                env.fillLists(){response in
                    switch response {
                    case .success:
                        // ici ce sont les cartes qui étaient déjà dans les UserSettings
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
