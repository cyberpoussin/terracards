//
//  MiniCardView.swift
//  TerraCards
//
//  Created by foxy on 13/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct MiniCardView: View {
    @Environment(\.verticalSizeClass) var sizeClass

    //@State var scale: CGFloat = DeviceManager.miniCardScale
    
    var scale: CGFloat {
        if !big {
            return DeviceManager.miniCardScale
        } else {
            return 0.8
        }
    }
    @State var zCoord: Double = 0.0
    @Binding var isACardClicked: Bool
    @Binding var opacity: CGFloat
    @State var big: Bool = false
    //@State var pos: CGPoint = CGPoint(x: 0, y: 0)
    @State var yWhenClicked: CGFloat = 0
    var pos: CGPoint {
        if big {
            let initialX: CGFloat = DeviceManager.miniCardScale == 0.25 ? 0 : UIScreen.main.bounds.width/3
            let xMultiplier: CGFloat = DeviceManager.miniCardScale == 0.25 ? 0 : 0
            let xCorrection: CGFloat = DeviceManager.miniCardScale == 0.25 ? (DeviceManager.cardWidth/3) : (DeviceManager.cardWidth*5/6)
            let initialY: CGFloat = DeviceManager.miniCardScale == 0.25 ? DeviceManager.cardHeight/3.5 : DeviceManager.cardHeight/2
            switch self.position {
            case 0 : return CGPoint(x: initialX, y: initialY - 1.2*yWhenClicked)
            // on mutiplie par un chiffre faible pour aller vers la droite
            case 1: return CGPoint(x: initialX - xCorrection, y: initialY - 1.2*yWhenClicked)
            case 2: return CGPoint(x: initialX - 2 * xCorrection, y: initialY - 1.2*yWhenClicked)
            default : return CGPoint(x:0, y: 200 - yWhenClicked)
        }
        } else {
            return CGPoint(x: 0, y: 0)
        }
    }
    
    var sourcePos: CGPoint = CGPoint(x: 0, y: 0)
    @ObservedObject var card: Card
    var bgColor: Color = Color.black
    var position: Int = 0

    var body: some View {
        
        return ZStack {
            
            
            
            GeometryReader { proxy in
                    ZStack {
                        if self.sizeClass == .compact {
                            self.bgColor
                            .opacity(self.big ? 1 : 0)
                        } else {
                            self.bgColor
                            .opacity(self.big ? 1 : 0)
                        }
                        
                        
                        CardFlip(bgColor: Color(self.card.collection.rawValue),versoView: {
                            AnyView(CardVerso(card: self.card))
                        }, rectoView: {
                            CardRecto(card: self.card)
                        })
                        
                    }
                        
                    .disabled(!self.big)
                        
                    .offset(x: self.pos.x, y: self.pos.y)
                        
                        .opacity(!self.big ? Double(self.opacity) : 1)
                        
                    
                    
                    .scaleEffect(self.big ? 0.8 : DeviceManager.miniCardScale, anchor: .topLeading)

                    .onTapGesture {
                        self.yWhenClicked = proxy.frame(in: .global).center.y
                        withAnimation(.linear(duration: 0)) {
                            if self.opacity == 0 {
                                self.opacity = 1
                            } else {
                                self.opacity = 0
                            }
                        }
                        if self.zCoord == 0 {
                            self.zCoord = 100
                        } else {
                            withAnimation(.linear(duration: 1)) {
                               self.zCoord = 0
                            }
                        }
                        
                        
                        if DeviceManager.isAnIphone {
                            GlobalTabBar.toggle()
                        }
                      
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 1)) {
                            
                            if !self.big {
                                self.big = true
                                self.isACardClicked = true
                                //self.pos = CGPoint(x: (270 - proxy.frame(in: .global).center.x), y: 600 - proxy.frame(in: .global).center.y)
                                

                            }
                            else {
                                self.big = false
                                self.isACardClicked = false
                            }
                        }
                        
                        
                    }
                
                .disabled(!self.big ? self.isACardClicked : false)
            }
        }
        .zIndex(zCoord)
    }
}


extension CGRect {
    var center : CGPoint {
        return CGPoint(x:self.midX, y:self.midY)
    }
}

struct MiniCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardView(isACardClicked: .constant(false), opacity: .constant(1), card: Card())
    }
}
