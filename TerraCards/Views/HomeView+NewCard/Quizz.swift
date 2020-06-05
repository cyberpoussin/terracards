//
//  Quizz.swift
//  TerraCards
//
//  Created by foxy on 04/06/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct Quizz: View {
    @State var showPlayAlertTwo = false
    var alreadyPlayed: Bool {
        UserSettings.nbQuizz >= 1
    }
    @State var activateLinkTwo = false
    @EnvironmentObject var cardsModelView: CardsLists

    var clearView = false
    
    var body: some View {
        VStack{
            NavigationLink(destination: NewCardsWonView(quizz: true, bgColor: Color(UIColor.systemPink)), isActive: self.$activateLinkTwo, label: {
                Button(action: {
                    if self.alreadyPlayed {
                        self.showPlayAlertTwo = true
                        self.activateLinkTwo = false
                    } else {
                        self.showPlayAlertTwo = false
                        if !UserSettings.illimitedQuizz {
                            UserSettings.nbQuizz = UserSettings.nbQuizz + 1
                        }
                        self.activateLinkTwo = true
                    }
                }) {
                    VStack{
                        Image("questionmark")
                            
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:90, height: 90)
                            .padding(.top, 0)
                        //.font(.title)
                             
                        Text("Surprise !")
                            .font(.footnote)
                            .padding(.top, -20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 60, height: 60)
                    .padding()
                    .background(Color(UIColor.systemPink))
                    .cornerRadius(15)
                    .foregroundColor(Color(UIColor.systemGray5))
                    .shadow(color: Color.white.opacity(0.4), radius: 5, x: -5, y: -5)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                    .padding(.horizontal, 10)
                    .opacity((!cardsModelView.possibleToWinMoreForFree && !alreadyPlayed) || clearView  ? 1 : 0.2)
                    .saturation((!cardsModelView.possibleToWinMoreForFree && !alreadyPlayed) || clearView  ? 1 : 0.2)
                }
            })
                

            
        }
        //.disabled(cardsModelView.possibleToWinMoreForFree)
        .alert(isPresented: $showPlayAlertTwo) {
            Alert(title: Text("Les quizz ne sont pas encore implémentés"), message: Text("Soutiens notre appli en votant sur l'App Store et nous pourrons les mettre en place"), dismissButton: .default(Text("OK")))
        }
    }
}


struct Quizz_Previews: PreviewProvider {
    static var previews: some View {
        Quizz()
    }
}
