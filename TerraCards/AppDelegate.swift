//
//  AppDelegate.swift
//  TerraCards
//
//  Created by MacBookGP on 07/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import UIKit
import SwiftUI

import BackgroundTasks
import Network

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    @ObservedObject var cards = CardsLists()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                

        
        
        
        registerBackgroundTaks()

        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("connected")
                DispatchQueue.main.async {
                    self.cards.connection = true
                }
                
            } else {
                print("disconnected")
                DispatchQueue.main.async {
                    self.cards.connection = false
                }
            }
        }
        
        monitor.start(queue: DispatchQueue.global())
        
        
        
        
        let REINIT = false
        UserSettings.illimitedQuizz = false
        if REINIT {
            UserSettings.lastFreeWins = "2001-01-01"
            UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.allCards.rawValue)
            FileProvider.clearImagesFromCacheFolder(){response in
                print("ok")
            }
            UserSettings.nbQuizz = 1
            UserSettings.userCards = []
        } else {
            UserSettings.nbQuizz = 0
            UserSettings.nbLaunches = UserSettings.nbLaunches + 1
            print("nombre de lancement de l'app : \(UserSettings.nbLaunches)")
            
//            if UserSettings.nbLaunches == 1 {
//                UserSettings.userCards = ["Mésange bleue", "Chêne", "Dauphin"]
//            }
//            print("cartes déjà gagnées : \(UserSettings.userCards)")
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateLastWins = dateFormatter.date(from: UserSettings.lastFreeWins)
            let dateToday = dateFormatter.date(from: dateFormatter.string(from: Date()))
            if let dateLastWins = dateLastWins, let dateToday = dateToday {
                if dateLastWins < dateToday {
                    UserSettings.nbQuizz = 0
                }
            }
            
            //desactivation des quizz
            UserSettings.nbQuizz = 1
        }
        
        
        
        
        //
        
        

        cards.fillLists {response in
            switch response {
            case .success:
                
                // télécharge la base et l'inscrit dans un fichier cache, dont on pourrait se servir pour la précharger en attente de connexion...
                
                //FileProvider.writeJsonInCache(data: data)
                // à retirer en prod
                var cardsToAdd: [Card] = []
                cardsToAdd.append(self.cards.allCards.first(where: {$0.name == "Mésange bleue"})!)
                cardsToAdd.append(self.cards.allCards.first(where: {$0.name == "Salamandre tâchetée"})!)
                cardsToAdd.append(self.cards.allCards.first(where: {$0.name == "Moustique tigre"})!)
                cardsToAdd.append(self.cards.allCards.first(where: {$0.name == "Jacinthe des bois"})!)
                cardsToAdd.append(self.cards.allCards.first(where: {$0.name == "Goujon"})!)
                self.cards.winCards(cards: cardsToAdd)
                for card in self.cards.wonCards {
                    print(card.name ?? "")
                }
                
            
            default:
                print("problem during downloading or decoding")
                // retry ??
            }
        }
        
        print("possible de gagner des cartes ? \(cards.possibleToWinMoreForFree)")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
    
    //MARK: Regiater BackGround Tasks
    private func registerBackgroundTaks() {
        print("on est là")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.TerraCards.fetchBackground", using: nil) { task in
            //This task is cast with processing request (BGProcessingTask)
            self.handleNewCardsFetcherTask(task: task as! BGProcessingTask)
        }
    }


}

extension AppDelegate {
    
    func cancelAllPandingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    func scheduleNewCardsFetcher() {
        let request = BGProcessingTaskRequest(identifier: "com.TerraCards.fetchBackground")
        request.requiresNetworkConnectivity = false // Need to true if your task need to network process. Defaults to false.
        request.requiresExternalPower = false
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 5) // Featch Image Count after 1 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule image featch: \(error)")
        }
    }
    
    
    func handleNewCardsFetcherTask(task: BGProcessingTask) {
        
        scheduleNewCardsFetcher() // Recall
        task.expirationHandler = {
            //This Block call by System
            //Canle your all tak's & queues
            self.cancelAllPandingBGTask()
        }

        cards.fetchAndFillAllCards {response in
            switch response {
            case .success:
                print("all cards fetched and loaded in background")
                task.setTaskCompleted(success: true)
            case .failure:
                print("problem during downloading or decoding in background")
                task.setTaskCompleted(success: false)
            }
        }
        
        

        
        
    }
}

