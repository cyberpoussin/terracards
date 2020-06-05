//
//  HomeView.swift
//  TerraCards
//
//  Created by Joséphine Delobel on 07/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

// Création de la grille
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack(spacing: self.vSpacing){
            ScrollView{
                ForEach(0 ..< rows, id:\.self){ row in
                    HStack(spacing: self.hSpacing){
                        ForEach(0 ..< self.columns, id:\.self){ column in
                            self.content(row, column)
                        }
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, hSpacing: CGFloat, vSpacing: CGFloat, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
    }
}




// Page HomeView
struct HomeView: View {
    
    @EnvironmentObject var cardsModelView: CardsLists
  
    let collectionTypes = CollectionType.allCases
    
    func isCollEmpty(collection: CollectionType) -> Bool {
        
        var numberOfCardsInCollection = 0
        let collectionEmpty : Bool = true
        
        cardsModelView.wonCards.forEach { card in
            if card.collection == collection {
                numberOfCardsInCollection += 1
            }
            else{
                print(cardsModelView.wonCards)
            }
        }
        
        if numberOfCardsInCollection == 0 {
            return collectionEmpty == true
        } else {
            return collectionEmpty == false
        }
    }
    
    @State private var showPlayAlertOne: Bool = false
    @State private var activateLinkOne: Bool = false
    
    @State var alreadyPlayed = false // à changer avec possibleToWinMoreForFree ?
    @State private var showPlayAlertTwo: Bool = false
    @State private var activateLinkTwo: Bool = false
    
    var body: some View {
            return ZStack {
                Color("generalBackgroundColor")
                .edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        Spacer().frame(height: 20)
                            .onAppear() {
                                GlobalTabBar.reAppear()
                        }

                        HStack{
                            
                            Gift()
                            .opacity(cardsModelView.possibleToWinMoreForFree ? 0.8 : 0.2)
                            .saturation(cardsModelView.possibleToWinMoreForFree ? 1 : 0.2)
                            Quizz()
                            
                        }
                        .padding(.top,5)
                        
                        // Mise en place de la grille des collections
                        GridStack(rows: 4, columns: 3, hSpacing: 7, vSpacing: 0){row, col in
                            VStack{
                                LittleCardView(titreCollection: self.collectionTypes[row * 3 + col].name, imageCollection: self.collectionTypes[row * 3 + col].image, couleurCard: self.collectionTypes[row * 3 + col].rawValue, type: self.collectionTypes[row * 3 + col]
                                ).saturation(self.isCollEmpty(collection: self.collectionTypes[row * 3 + col]) ? 0.25 : 1)
                                    .opacity(self.isCollEmpty(collection: self.collectionTypes[row * 3 + col]) ? 0.25 : 1)
                                
                            }.padding(.top, 5)
                            
                        }
                        Spacer().frame(height: 50)
                    }
                }
            }
        
        //.edgesIgnoringSafeArea(.all)
        
        
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let env = CardsLists()
        return HomeView()
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
