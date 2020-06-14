//
//  LittleCardView.swift
//  TerraCards
//
//  Created by Joséphine Delobel on 11/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI


struct Layers: View {
    var doubleLayers: CGFloat

    var doubleIntLayers: Int { Int(doubleLayers)}


    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
            .frame(width: 100, height: 140)
            .offset(x: (self.doubleLayers) * 0.5, y: (self.doubleLayers) * 0.5)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
            
            ForEach((0..<doubleIntLayers), id: \.self) {i in
                RoundedRectangle(cornerRadius: 25)
                .fill(i % 2 == 0 ? Color(UIColor.systemGray2) : Color(UIColor.systemGray3))
                .frame(width: 100, height: 140)
                .offset(x: (self.doubleLayers - CGFloat(i)) * 0.5, y: (self.doubleLayers - CGFloat(i)) * 0.5)
            }
        
        }
    }
}

struct LittleCardView: View {
    var titreCollection : String
    var imageCollection : String
    var couleurCard: String
    
    func numberOfLayers(collection: CollectionType) -> Int {
        var layers: Int = 0
        cardsModelView.wonCards.forEach { card in
            if card.collection == collection {
                layers += 1
            }
            else{
                print(cardsModelView.wonCards)
            }
        }
        return layers
    }
    
    var doubleLayers: CGFloat { CGFloat(numberOfLayers(collection: type) * 2) }
    
    @State private var showingAlert = false
    @State private var activateLink: Bool = false
    @State var type : CollectionType
    
    @EnvironmentObject var cardsModelView: CardsLists
    
    func isCollectionEmpty(collection: CollectionType) -> Bool {

        var numberOfCardsInCollection = 0

        cardsModelView.wonCards.forEach { card in
            if card.collection == collection {
                numberOfCardsInCollection += 1
            }
            else{
                print(cardsModelView.wonCards)
            }
        }

        if numberOfCardsInCollection == 0 {
            return showingAlert == false
        } else {
            return showingAlert == true

        }
    }
    
    // création de l'extractingView pour la HomeView
    var body: some View {
            
            VStack{
                NavigationLink(destination: CollectionView(collection: self.type).environmentObject(self.cardsModelView), isActive: $activateLink, label: {
                    Button(action: {
                        if self.isCollectionEmpty(collection: self.type) {
                            self.showingAlert = true

                        } else {
                            self.showingAlert = false
                            self.activateLink = true
                        }
                    }) {
                        VStack {
                            ZStack{
                                
                                Layers(doubleLayers: doubleLayers)

                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.white).frame(width: 100, height: 140)
                                
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color(couleurCard).opacity(0.6))
                                    .frame(width: 100, height: 140)
                                    //.shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                                    //.shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
                                    .padding(.horizontal, 10)
                                    .overlay(Image("\(imageCollection)").renderingMode(.original).resizable().scaledToFit().frame(width: 90, height: 90)
                                        //.blendMode(.multiply)
                                    )
                            }
                            Text (titreCollection)
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                        }
                    }
                })
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Pas encore de cartes dans cette catégorie"), message: Text("Tu peux gagner de nouvelles cartes tous les jours en cliquant sur le cadeau"), dismissButton: .default(Text("OK")))
            }
   
    }
}

struct LittleCardView_Previews: PreviewProvider {
    static var previews: some View {
        LittleCardView(titreCollection: "Amphibiens", imageCollection : "grenouille2", couleurCard: "amphibian", type: .amphibian)
    }
}
