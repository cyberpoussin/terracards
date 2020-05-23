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
    
    var collection: CollectionType?
    var cardList: [Card]?
    
    init(collection: CollectionType) {
        self.collection = collection
        self.cardList = nil
    }
    
    init(cardList: [Card]) {
        self.collection = nil
        self.cardList = cardList
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
    let bgColor: Color = Color("tree")
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
            VStack {
                //Spacer().frame(height: 130)
                Spacer()
            }
                
            .frame(width: UIScreen.main.bounds.width * 100/100, height: UIScreen.main.bounds.height * 120/100)
                
            .background(Color(collec.isEmpty ? "fish" : collec[0].collection.rawValue))
            
            ScrollView {
                
                VStack(spacing: 0) {
                    ForEach(collec3by3, id: \.self, content: {row in
                        HStack {
                            ForEach(0..<3) { i in
                                //MiniCardView( isACardClicked: self.$isACardClicked, opacity: self.opacityCards, disappear: self.disappear, card: row[i])
                                if i < row.count {
                                    MiniCardView( isACardClicked: self.$isACardClicked, opacity: self.$opacityCards,  card: row[i])
                                } else {
                                    MiniCardView( isACardClicked: self.$isACardClicked, opacity: self.$opacityCards, card: Card()).hidden()
                                }
                            }
                        }
                        
                        
                        //Text("hahahahaha")
                        
                        
                        
                    })
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 100/100, height: isACardClicked ? UIScreen.main.bounds.height * 120/100 : CGFloat(500 * Int(collec3by3.count)))
                
                
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(collection: .plant).environmentObject(CardsLists())
    }
}
