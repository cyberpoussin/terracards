//
//  AppView.swift
//  TerraCards
//
//  Created by MacBookGP on 13/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct AppView: View {
    @Environment(\.verticalSizeClass) var size
    @EnvironmentObject var cardsModelView: CardsLists
    @ObservedObject var helpViewManager: HelpViewManager = HelpViewManager()

    
    
    
    
    var body: some View {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = coloredAppearance
               UINavigationBar.appearance().compactAppearance = coloredAppearance
               UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
               UINavigationBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = UIColor(named: "generalBackgroundColor")
        //UITabBar.appearance().backgroundColor = UIColor.black
          //UITabBar.appearance().barTintColor?.withAlphaComponent(0.3)
//        UITabBar.appearance().backgroundImage =  UIImage()
//
//        //UITabBar.appearance().isOpaque = false
//        //UITabBar.appearance().tintColor = .green
            //UITabBar.appearance().alpha = 0.2
            UITabBar.appearance().isTranslucent = true
//
//        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//        frost.frame = UITabBar.appearance().bounds
//        frost.autoresizingMask = .flexibleWidth
//
//        UITabBar.appearance().insertSubview(frost, at: 0)
        

        return ZStack {
            
            //NavigationView {
            TabView(selection: $helpViewManager.changeItemSelection) {
                    NavigationView {
                        HomeView()
                        .navigationBarTitle("Collections", displayMode: .inline)
                        .navigationBarHidden(true)
                        
                    }.navigationViewStyle(StackNavigationViewStyle())
                    
                    .tabItem({
                        Image(systemName: "book")
                        Text("Collections")
                    })
                        .tag(1)

                    TropheesView()
                        .tabItem({
                            // Image("icons8-book-stack-50")
                            Image(systemName: "rosette")
                            Text("Trophées")
                        }).tag(2)

//                    ParametresView(user: [UserLocation.init(user: .init(latitude: 23, longitude: 34))])
//                        .tabItem({
//                            Image(systemName: "gear")   // "helm"
//                            Text("Environnement")
//                        })

                        Help(helpViewManager: helpViewManager)
                        .tabItem({
                            Image(systemName: "questionmark.square")
                            Text("Aide")
                        }).tag(3)

                    
                        
                        
            }
                if UserSettings.nbLaunches == 1 {
                    Help(helpViewManager: helpViewManager).environmentObject(cardsModelView)
                        
                }
                
            }


            
            
            
            
       // }

        //.accentColor(.blue)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}



