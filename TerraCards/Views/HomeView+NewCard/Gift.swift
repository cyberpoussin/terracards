//
//  Gift.swift
//  TerraCards
//
//  Created by foxy on 04/06/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct Gift: View {
    @State var showPlayAlertOne = false
    @State var activateLinkOne = false
    @EnvironmentObject var cardsModelView: CardsLists
    var body: some View {
        VStack{
            NavigationLink(destination: NewCardsWonView(bgColor: Color(UIColor.systemTeal)), isActive: self.$activateLinkOne, label: {
                Button(action: {
                    if !self.cardsModelView.possibleToWinMoreForFree {
                        self.showPlayAlertOne = true
                        self.activateLinkOne = false

                    } else {
                        self.showPlayAlertOne = false
                        self.activateLinkOne = true

                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                                                    .fill(                Color("backGift")
                        )
                                                    .frame(width: 92, height: 92)
                            .shadow(color: Color.white.opacity(0.4), radius: 5, x: -5, y: -5)
                            .shadow(color: Color.black.opacity(0.13), radius: 5, x: 5, y: 5)
                        
                            
                        VStack{
                            Image("gift")
                                
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:95, height: 95)
                            //.padding(.top, 20)
                            //.font(.title)
                                 
                            Text("Cadeaux")
                                .font(.footnote)
                                .padding(.top, -22)
                            
                        }
                            //.background(Color(UIColor.systemTeal).opacity(0.6))
                        .frame(width: 92, height: 92)
                        //.clipped()
                        .padding()
                        
                        .cornerRadius(15)
                        .foregroundColor(Color(UIColor.systemGray5))
                        
                        
                        //.padding(.horizontal, 10)
                    }
                    
                }
            })
                .onAppear(){
                    print("lool : \(self.cardsModelView.possibleToWinMoreForFree)")
                    if !self.cardsModelView.possibleToWinMoreForFree {
                        self.activateLinkOne = false

                    }
            }
            //.disabled(!cardsModelView.possibleToWinMoreForFree)
        }.alert(isPresented: $showPlayAlertOne) {
            Alert(title: Text("Tu as déjà gagné des cartes aujourd'hui"), message: Text("On t'offrira de nouvelles cartes demain"), dismissButton: .default(Text("OK")))
        }
    }
}


struct Gift_Previews: PreviewProvider {
    static var previews: some View {
        Gift()
    }
}
