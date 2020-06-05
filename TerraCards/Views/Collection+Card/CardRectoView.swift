//
//  CardView.swift
//  TerraCards
//
//  Created by foxy on 11/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct CardRecto: View {
    @ObservedObject var card: Card
    @Environment(\.verticalSizeClass) var sizeClass


    
    var body: some View {
        VStack {
            
            ZStack {
                
                
                
                    ZStack {
                            Color("cardBackground")

                            if card.imageRecto != nil && card.imageVerso != nil {
                                card.imageRecto!
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 30)
                                .blendMode(.multiply)
                            } else {
                                Image(card.collection.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 30)
                                .blendMode(.multiply)
                                .saturation(0.0)
                                .opacity(0.3)
                                .onAppear() {
                                    self.card.loadingImages()
                                }
                            }
                            
                        }
                    .frame(height: DeviceManager.cardHeight * 1/2)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 0)

                        
                        
                
                
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark")
                            .frame(width: 20)
                            .padding()
                            .overlay(
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .padding(6)
                        )
                            .padding(.trailing, 20)
                            .padding(.top, 30)
                            .opacity(0.3)
                        
                        
                    }
                    Spacer()
                }
                
            }
            
            
                
            Spacer()
            
            HStack {
                Text(card.name)
                    .font(.title)
            }
            Spacer()
            HStack(spacing: 20) {
                ForEach(card.habitats, id: \.self) { habitat in
                    VStack {
                        Image(habitat.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:25, height: 25)
                        Text(habitat.name)
                            .font(.footnote)
                    }
                }
                
                
            }
            .opacity(0.6)
            
            Spacer().frame(height: 30)
        }
    }
}

struct CardRecto_Previews: PreviewProvider {
    static var previews: some View {
        CardRecto(card: Card())
    }
}
