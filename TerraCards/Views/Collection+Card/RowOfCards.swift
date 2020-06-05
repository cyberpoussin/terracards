//
//  RowOfCards.swift
//  TerraCards
//
//  Created by foxy on 27/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct RowOfCards: View {
    @State var clicked = false
    @State var opacity: CGFloat = 1.0
    var body: some View {
        ScrollView {
            VStack(spacing: 250) {
        HStack(spacing: 0) {
            MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 0)
                //.position(x:0, y: 0)
            MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 1)
                //.offset(x: -138 , y: 0)
            MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 2)
        }
            HStack(spacing: 0) {
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 0)
                    //.position(x:0, y: 0)
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 1)
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 2)
            }
            HStack(spacing: 0) {
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 0)
                    //.position(x:0, y: 0)
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 1)
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 2)
            }
            HStack(spacing: 0) {
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 0)
                    //.position(x:0, y: 0)
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 1)
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 2)
            }
            HStack(spacing: 0) {
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 0)
                    //.position(x:0, y: 0)
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 1)
                MiniCardView(isACardClicked: $clicked, opacity: $opacity, card: Card(), position: 2)
            }
        }
    }
    }
}

struct RowOfCards_Previews: PreviewProvider {
    static var previews: some View {
        RowOfCards()
    }
}
