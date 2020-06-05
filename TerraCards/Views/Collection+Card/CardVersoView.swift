//
//  CardVersoView.swift
//  TerraCards
//
//  Created by foxy on 07/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct CardVerso: View {
    @ObservedObject var card: Card
    @Environment(\.verticalSizeClass) var sizeClass

    struct imageDefault: View {
        var body: some View {
            Image("photoChene")
                .saturation(0.0)
                .opacity(0.3)
        }
    }

    var body: some View {
        VStack {
//            ZStack {
//
//                VStack {
//                    HStack {
//                        Spacer()
//                        Image(systemName: "xmark")
//                            .frame(width: 20)
//                            .padding()
//                            .overlay(
//                                Circle()
//                                    .stroke(lineWidth: 1)
//                                    .padding(6)
//                        )
//                            .padding(.trailing, 20)
//                            .padding(.top, 30)
//                            .opacity(0.3)
//
//                    }
//                    Spacer()
//                }
//
//            }
//            .clipped()
            VStack {
//                Capsule().overlay(Image("photoChene")
//                //.resizable()
//                )
                if card.imageVerso != nil {
                    card.imageVerso!
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: DeviceManager.cardWidth, height: DeviceManager.orientation == .landscape ? DeviceManager.cardHeight/2 : DeviceManager.cardHeight/2.5, alignment: .center)
                        .clipped()
                        //.frame(width: DeviceManager.cardWidth, alignment: .top)
                        .cornerRadius(12)
                        .contentShape(Rectangle())
                } else {
                    Spacer()
                    .frame(width: DeviceManager.cardWidth, height: DeviceManager.cardHeight/2, alignment: .center)
                }
                //Spacer()
            }.frame(width: DeviceManager.cardWidth)

            .allowsHitTesting(false)
            
            //Spacer().frame(height: DeviceManager.cardHeight/10)
            
            HStack {
                Text(card.name)
                    .font(.title)
            }
            //Spacer()
            HStack {
                Text(card.anecdote ?? "")
                    .padding(.horizontal, 20)
            }
            .frame(height: DeviceManager.cardHeight/4)
            
            Spacer().frame(height: 50)
            Spacer()
        }
    }
}

struct CardVerso_Previews: PreviewProvider {
    static var previews: some View {
        CardVerso(card: Card())
    }
}
