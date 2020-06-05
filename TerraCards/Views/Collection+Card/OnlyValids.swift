//
//  OnlyValids.swift
//  TerraCards
//
//  Created by foxy on 28/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct OnlyValids: View {
    @State var cards: [Card] = []
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        VStack {
        ForEach(cards) {card in
            Text(card.name)
        }
            if horizontalSizeClass == .compact {
                Text("compact")
            } else if horizontalSizeClass == .regular {
                Text("regular")
            }
            Text(horizontalSizeClass.debugDescription)
            .onAppear() {
                APIProvider.shared.requestAllRecordsValidated(completion: {result in
                    switch result {
                    case let .success(response):
                        switch response {
                        case let .data(data):
                            JSONProvider.decodeToCardList(from: data, completion: {res in
                                switch res {
                                case let .success(cardlist):
                                self.cards = []
                                for cardRecord in cardlist.records {
                                    self.cards.append(cardRecord.fields)
                                }
                                default: print("NOON")
                                }
                            })
                        default: print("non")
                        }
                    case let .failure(error): print("aie aie \(error)")
                    }
                })
                
                APIProvider.shared.requestLastUpdate(completion: {result in
                    switch result {
                    case let .success(response):
                        switch response {
                        case let .data(data):
                            JSONProvider.decodeToCardList(from: data, completion: {res in
                                switch res {
                                case let .success(cardlist):
                                    var dates: [Card] = []
                                for cardRecord in cardlist.records {
                                    dates.append(cardRecord.fields)
                                }
                                    print("les dates : \(dates[0].lastModifTime)")
                                default: print("NOON")
                                }
                            })
                        default : print("raté")
                        }
                    case .failure: print("houla")
                    }
                })
        }
        }
    }
}

struct OnlyValids_Previews: PreviewProvider {
    static var previews: some View {
        OnlyValids().environment(\.horizontalSizeClass, .compact)
    }
}
