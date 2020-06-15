//
//  Help.swift
//  TerraCards
//
//  Created by MacBookGP on 13/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct Help: View {
    
    @EnvironmentObject var cardsModelView: CardsLists
    @ObservedObject var helpViewManager: HelpViewManager
    @Environment(\.verticalSizeClass) var size

    
    var nbCard: Int? {
        return cardsModelView.allCards.firstIndex {
            $0.name == "Mésange bleue"
        }
    }
    
    var onBoarding: Bool {
        UserSettings.nbLaunches == 1
    }
    
    
    var body: some View {
        let drag = DragGesture()
            .onChanged({value in
                if  value.translation.width < 0 {
                    self.helpViewManager.offset[self.helpViewManager.sheet].width = value.translation.width
                }
            })
            .onEnded({value in
                withAnimation(.linear(duration: 0.5)) {
                    if self.helpViewManager.offset[self.helpViewManager.sheet].width < -100 {
                        
                        self.helpViewManager.offset[self.helpViewManager.sheet].width = -1 * UIScreen.main.bounds.width - 1000
                    } else {
                        self.helpViewManager.offset[self.helpViewManager.sheet].width = 0
                    }
                }
                
                if self.helpViewManager.offset[self.helpViewManager.sheet].width < -100 {
                    self.helpViewManager.sheet += 1
                    withAnimation(.linear(duration: 0.5)) {
                        if self.helpViewManager.sheet < self.helpViewManager.showed.count {
                            self.helpViewManager.showed[self.helpViewManager.sheet].toggle()
                        }
                    }
                }
            })
        
        return
            ZStack {
                ZStack {
                    Color("bird")
                        .edgesIgnoringSafeArea(.all)
                    
                    if self.helpViewManager.sheet == 3 && !onBoarding{
                        Text("")
                            .onAppear() {
                                GlobalTabBar.reAppear()
                                
                        }
                    }
                    
                    if self.helpViewManager.sheet == 4 {
                        Text("")
                            .onAppear() {
                                        UserSettings.nbLaunches += 1
                                
                        }
                    }
                    
                    ThreeVerticalView(delays: [1,1,2], arrow: false,
                                      firstView: {
                                        ThreeWords(sentence: "Collectionne les toutes")
                                            .font(.title)
                    }, secondView: {
                            Text("Tes cartes gagnées sont rangées dans des collections (plantes, oiseaux, poissons, etc.) Pour commencer, tu en as déjà 5. Découvre vite où elles sont rangées et les informations qu'elles contiennent.")
                                .padding(40)
                                
                                .transition(.move(edge: .bottom))
                    }, thirdView: {
                        HStack {
                            if self.onBoarding {
                                ThreeWords(sentence : "Glisse pour commencer !")
                            } else {
                                Text("Fin...")
                            }
                        }
                    })
                }
                .onAppear() {
                    withAnimation(.linear(duration: 0.5)) {
                        //self.showed2.toggle()
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .offset(x: self.helpViewManager.offset[3].width, y: 0)
                .gesture(drag)
                .disabled(self.helpViewManager.sheet != 3 || !onBoarding)
                
                
                GreenSheet(helpViewManager: helpViewManager)
                .frame(width:UIScreen.main.bounds.width)
                .offset(x: self.helpViewManager.offset[2].width, y: 0)
                .gesture(drag)
                .disabled(self.helpViewManager.sheet != 2)
                
                BlueSheet(helpViewManager: helpViewManager, cardsModelView: cardsModelView, nbCard: nbCard)
                .frame(width:UIScreen.main.bounds.width)
                .offset(x: self.helpViewManager.offset[1].width, y: 0)
                .gesture(drag)
                .disabled(self.helpViewManager.sheet != 1)
                
                
                RedSheet(onBoarding: onBoarding)
                .frame(width:UIScreen.main.bounds.width)
                    
                .offset(x: self.helpViewManager.offset[0].width, y: 0)
                .gesture(drag)
            }
    }
}

struct GreenSheet: View {
    @ObservedObject var helpViewManager: HelpViewManager
    @Environment(\.verticalSizeClass) var size
    var body: some View {
        ZStack {
            Color("tree")
                .edgesIgnoringSafeArea(.all)
            
            if helpViewManager.showed[2] {
                ThreeVerticalView(delays: [1,2,3],
                                  firstView: {
                                    Text("Gagne des cartes chaque jour !")
                                        .font(.title)
                }, secondView: {
                    VStack {
                        HStack {
                            Quizz(clearView: true)
                                
                                .disabled(true)
                            Gift()
                                
                                .disabled(true)
                        }
                        
                        Text("Tous les matins un nouveau cadeau apparaît dans TerraCards. Il contient trois nouvelles cartes. Si tu as encore soif de connaissances, participe à des quiz pour gagner encore plus de cartes.")
                            
                            .padding(.horizontal, 40)
                            .transition(.move(edge: .bottom))
                        
                    }
                }, thirdView: {
                    ThreeWords(sentence : "Glisse pour continuer")
                    
                    //.foregroundColor(Color.white)
                    
                })
            }
        }
        .onAppear() {
            withAnimation(.linear(duration: 3)) {
                //self.showed2.toggle()
            }
        }
        
        
        
        
        
    }
}

struct BlueSheet: View {
    @ObservedObject var helpViewManager: HelpViewManager
    @ObservedObject var cardsModelView: CardsLists
    @Environment(\.verticalSizeClass) var size

    var nbCard: Int?
    var body: some View {
        ZStack {
            Color(UIColor.systemTeal)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if nbCard != nil {
                    CardFlip(flip: $helpViewManager.endFlip, versoView: {
                        AnyView(CardVerso(card: cardsModelView.allCards[nbCard!]))
                    }, rectoView: {
                        AnyView(CardRecto(card: cardsModelView.allCards[nbCard!]))
                    })
                        .scaleEffect(0.4)
                        .frame(height: DeviceManager.cardHeight*0.4)
                        .disabled(helpViewManager.endFlip)
                }
                
                Text("Dans TerraCards tu collectionnes des cartes qui comportent des informations sur les animaux et les plantes des environs. Retourne celle-ci pour voir !")
                    .padding(.vertical, 30)
                    .padding(.horizontal, 30)
                    
                
                if helpViewManager.endFlip {
                    HStack {
                        AnimatedChevron()
                        Text("Glisse pour continuer")
                            .foregroundColor(Color.white)
                        
                        
                    }
                    .opacity(helpViewManager.opacity)
                    .onAppear() {
                        withAnimation(.linear(duration: 1)) {
                            self.helpViewManager.opacity = 1
                        }
                    }
                    
                } else {
                    HStack {
                        AnimatedChevron()
                        Text("Glisse pour continuer")
                            .foregroundColor(Color.white)
                    }.hidden()
                }
                

            }.padding(.horizontal, 140)
        }
    }
}

struct RedSheet: View {
    var onBoarding: Bool
    var body: some View {
        ZStack {
            Color(UIColor.systemPink)
                .edgesIgnoringSafeArea(.all)
                .onAppear() {
                    if !self.onBoarding {
                        GlobalTabBar.disappear()
                    }
            }
            
            ThreeVerticalView(delays: [2.5,5,0],
                              firstView: {
                                ThreeWords(sentence: "Bienvenue dans TerraCards")
                                    .font(.title)
            }, secondView: {
                VStack {
                    //if self.showed[0] {
                    Text("Avec TerraCards tu vas apprendre à mieux connaître la faune et la flore qui t'entoure. Que tu habites à la campagne, au bord de la mer, ou même en ville")
                        
                        .padding(40)
                        .transition(.move(edge: .bottom))
                    
                }
            }, thirdView: {
                ThreeWords(sentence : "Glisse pour continuer")
                
                //.foregroundColor(Color.white)
                
            })
            
            
        }
    }
}


struct ThreeWords: View {
    
    var words: [String]
    @State var opacities: [Double]
    init(sentence: String) {
        self.words = sentence.map { String($0) }
        self._opacities = State(initialValue: Array(repeating: 0.0, count: self.words.count))
    }
    
    init(arrayOfWords: [String]) {
        self.words = arrayOfWords
        self._opacities = State(initialValue: Array(repeating: 0.0, count: self.words.count))
    }
    
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach (0..<words.count) {i in
                    Text(self.words[i])
                        .padding(0)
                        .opacity(self.opacities[i])
                }
            }.onAppear() {
                for i in 0..<self.opacities.count {
                    withAnimation(Animation.linear(duration: 0.5).delay(Double(i)*0.05)) {
                        self.opacities[i] = 1
                        
                    }
                }
                
            }
        }
    }
}

struct AnimatedChevron: View {
    @State var chevronX: CGFloat = 0
    @State var opacityChevron: Double = 1
    
    var body: some View {
        Image(systemName: "chevron.left")
            .offset(x: self.chevronX, y: 0)
            .foregroundColor(Color.white)
            .opacity(self.opacityChevron)
            .onAppear() {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)){
                    self.chevronX = -100
                }
                withAnimation(Animation.easeOut(duration: 2).repeatForever(autoreverses: false)) {
                    self.opacityChevron = 0
                    
                }
        }
    }
}

struct ThreeVerticalView<FirstView: View, SecondView: View, ThirdView: View>: View {
    var delays: [Double]
    var arrow = true
    var firstView: () -> FirstView
    var secondView: () -> SecondView
    var thirdView: () -> ThirdView
    @State var show = false
    @State var opacities: [Double] = [0, 0, 0]
    @State var showed = false
    var body: some View {
        VStack {
            firstView().opacity(self.opacities[0])
            
            secondView().opacity(self.opacities[1])
            if self.showed {
                HStack {
                    if arrow {
                        AnimatedChevron()
                    }
                    thirdView()
                        .foregroundColor(Color.white)
                    
                    
                }
            }
            else {
                HStack {
                    if arrow {
                        AnimatedChevron()
                    }
                    thirdView()
                        .foregroundColor(Color.white)
                    
                    
                }.hidden()
            }
        }.onAppear() {
            for i in 0..<self.opacities.count {
                withAnimation(
                    Animation.linear(duration: 1)
                        .delay(i == 0 ? 0 : self.delays[i-1]))
                {
                    self.opacities[i] = 1
                }
            }
        }
        .onAppear() {
            withAnimation(Animation.linear.delay(self.delays[1])) {
                self.showed.toggle()
            }
        }
    }
}

struct Help_Previews: PreviewProvider {
    static var previews: some View {
        let env = CardsLists()
        let hvmanager = HelpViewManager()
        return Help(helpViewManager: hvmanager)
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
