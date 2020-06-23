//
//  CollectionView.swift
//  TerraCards
//
//  Created by foxy on 07/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var cardsModelView: CardsLists
    @Environment(\.verticalSizeClass) var sizeClass
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var collection: CollectionType?
    var cardList: [Card]?
    
    init(collection: CollectionType) {
        self.collection = collection
        self.cardList = nil
        self.bgColor = nil
    }
    
    init(cardList: [Card], bgColor: Color = Color.white) {
        self.collection = nil
        self.cardList = cardList
        self.bgColor = bgColor
    }
    
    var collec: [Card] {
        if cardList == nil {
            return cardsModelView.wonCards.filter({$0.collection == self.collection})
        } else {
            return cardList!
        }
    }
    
    var collec3by3: [[Card]] {
        var result: [[Card]] = []
        if collec.isEmpty {
            return []
        }
        for i in 0...collec.count/3 {
            var more: [Card] = []
            for j in 0...2 {
                print("zouzou \(i*3+j)")
                if i*3+j < collec.count {
                    more.append(collec[i*3+j])
                }
            }
            if !more.isEmpty {
                result.append(more)
            }
        }
        print("le compte est bon: \(result.count)")
        return result
    }
    
    @State var isACardClicked: Bool = false
    let bgColor: Color?
    @State var opacityCards: CGFloat = 1
//    func disappear() {
//
//        if opacityCards == 1 {
//            withAnimation(.linear(duration: 0.15)) {
//                opacityCards = 0
//            }
//        } else {
//            withAnimation(.linear(duration: 0.6)) {
//                opacityCards = 1
//            }
//        }
//
//    }
    
    var body: some View {
        ZStack {
            if collec.isEmpty {
                if bgColor != nil {
                    bgColor!
                } else {
                    Color("fish")
                }
            } else {
                if bgColor != nil {
                    bgColor!
                } else {
                    Color(collec[0].collection.rawValue)
                }
            }
                
            
            
            ScrollView {
                Spacer().frame(height: 80)
                VStack(spacing: 0) {
                    ForEach(collec3by3, id: \.self, content: {row in
                        HStack(spacing: 0) {
                            ForEach(0..<3) { i in
                                //MiniCardView( isACardClicked: self.$isACardClicked, opacity: self.opacityCards, disappear: self.disappear, card: row[i])
                                if i < row.count {
                                    MiniCardView( isACardClicked: self.$isACardClicked, opacity: self.$opacityCards,  card: row[i] , bgColor: self.bgColor ?? Color(self.collec[0].collection.rawValue), position: i)
                                        .frame(height: DeviceManager.cardHeight*DeviceManager.miniCardScale)
                                        .padding(0)
                                } else {
                                    MiniCardView( isACardClicked: self.$isACardClicked, opacity: self.$opacityCards, card: Card())
                                        .frame(height: DeviceManager.cardHeight*DeviceManager.miniCardScale)
                                        .hidden()
                                }
                            }
                        }
                        
                        .padding(.horizontal, DeviceManager.orientation == .portrait ? 20 : 30)
                        .padding(.vertical, DeviceManager.orientation == .portrait ? 10 : 20)

                        
                        
                        
                        //Text("hahahahaha")
                        
                        
                        
                    })
                    if  collec3by3.count < 3 {
                        ForEach(0..<(3 - collec3by3.count)) {_ in
                            HStack {
                                Spacer().frame(height: DeviceManager.cardHeight*0.25)
                            }
                        }
                    }
                }
                //.frame(width: UIScreen.main.bounds.width * 100/100)
                Spacer().frame(height: 120)
                
            }            
        }
        .navigationBarBackButtonHidden(true)

        .navigationBarItems(leading:  Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Collections")
                    //.padding(.leading, -15)
            }
            
                
            }
        )
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
        
        //.navigationBarBackButtonHidden(false)

        //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        //.zIndex(100)
        
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        //CollectionView(collection: .plant).environmentObject(CardsLists())
        var env = CardsLists()
        return CollectionView(cardList: Array(repeating: Card(), count: 12)).environmentObject(CardsLists())
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
                        cardsToAdd.append(env.allCards.first(where: {$0.name == "Lérot"})!)
                        env.winCards(cards: cardsToAdd)
                        

                    case .failure :
                        print("mince")
                    }
                }
                
        }

    }
}
