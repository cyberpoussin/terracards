//
//  CardTest3.swift
//  TerraCards
//
//  Created by foxy on 12/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct CardFlip<Content: View, Content2: View>: View {
    @Environment(\.verticalSizeClass) var sizeClass
    
    @State var currentPosition: CGSize = .zero
    @State var currentAngle: Double = .zero
    var currentAngleMod: Double {
        if (89.7...90.3).contains(abs(currentAngle)) {
            return 89.7*(currentAngle/abs(currentAngle))
        }
        else if (269.7...270.3).contains(abs(currentAngle)) {
            return 269.7*(currentAngle/abs(currentAngle))
        } else {
            return currentAngle
        }
    }
    @State var shadow: CGFloat = 4
    
    var left: Bool {
        if !self.flip {
            if recto {
                return currentAngle<0
            }  else {
                return currentAngle>0
            }
        } else {
            if recto {
                return currentAngle>0
            }  else {
                return currentAngle<0
            }
        }
        
        
    }
    @State var flip = false
    @Binding var flipBinding: Bool
    @State var newPosition: CGSize = .zero
    var recto: Bool {
        
        let q = Int(currentAngle).quotientAndRemainder(dividingBy: 90).0
        print("bon \(q)")
        if abs(q) == 0 || abs(q) == 3 || abs(q) == 4{
            return true
        } else {
            return false
        }
    }
    let gap = 0
    
    
    
    var drag: some Gesture {
        var flipped: Bool {
            get {
                self.flip
            }
            set(newValue) {
                self.flip = newValue
                self.flipBinding = newValue
            }
        }
        return DragGesture()
            .onChanged { value in
                
                //self.currentPosition.height =  self.newPosition.height + value.translation.height
                
                let gap: CGFloat = CGFloat(self.gap)
                let negGap: CGFloat = -1*gap
                
                let totalTrans =  self.newPosition.width + value.translation.width
                
                if  Int(self.currentAngle+1) % 180 != 0 &&
                    Int(totalTrans).quotientAndRemainder(dividingBy: Int(180*1.7) + Int(gap)).1 < Int(gap) &&
                    Int(totalTrans).quotientAndRemainder(dividingBy: Int(180*1.7) - Int(gap)).1 > Int(negGap)
                {
                    self.currentPosition.width = totalTrans
                    return
                }
                if totalTrans > 0 {
                    self.currentAngle = Double((totalTrans - gap)/1.7)
                } else {
                    self.currentAngle = Double((totalTrans + gap)/1.7)
                }
                
                if self.currentAngle > 179 {
                    self.currentAngle = 179
                }
                if self.currentAngle < -179 {
                    self.currentAngle = -179
                    
                }
                if flipped {
                    if self.currentAngle >= 0 {
                        self.currentAngle += 180
                    } else {
                        self.currentAngle -= 180
                    }
                }
                if self.currentAngle > 0 {
                    self.currentPosition.width =  gap + (value.translation.width - gap)/2
                } else {
                    
                    self.currentPosition.width =  negGap + (value.translation.width + gap)/2
                    print("mygod \(self.currentPosition.width)")
                }
                
                withAnimation() {
                    if Int(self.currentAngle)%180 == 0 {
                        self.shadow = 4*(flipped ? -1 : 1)
                    } else {
                        self.shadow = 0
                    }
                    
                }
                
        }
        .onEnded { value in
            let q = Int(self.currentAngle).quotientAndRemainder(dividingBy: 90).0
            print("hehe \(q)")
            var resetAngle: Double = 0
            if abs(q) == 0 || abs(q) % 2 == 0 {
                if flipped && self.currentAngle > 0{
                    resetAngle = Double(180)
                }
                else if (flipped && self.currentAngle < 0) {
                    resetAngle = Double(-180)
                    
                } else {
                    resetAngle = 0
                }
            }
            else {
                if !flipped {
                    resetAngle = Double(180*(q/abs(q)))
                    flipped = true
                } else {
                    resetAngle = Double(360*q/abs(q))
                    flipped = false
                }
            }
            
            withAnimation() {
                self.currentAngle = resetAngle
                
                self.currentPosition.width = 0
                self.newPosition.width = 0
            }
            
            self.newPosition = self.currentPosition
            
            
            withAnimation() {
                if Int(self.currentAngle)%180 == 0 {
                    self.shadow = 4*(flipped ? -1 : 1)
                } else {
                    self.shadow = 0
                }
                
            }
            
        }
    }
    
    let bgColor: Color
    
    let versoView: Content2
    let rectoView: Content
    

    
    @inlinable public init(flip: Binding<Bool> = .constant(false), bgColor: Color = Color.red, @ViewBuilder versoView: () -> Content2, @ViewBuilder rectoView: () -> Content) {
        self.versoView = versoView()
        self.rectoView = rectoView()
        
        self.bgColor = bgColor
        self._flipBinding = flip

    }
    var body: some View {
        ZStack {
            ZStack {
                versoView
                    .background(bgColor.opacity(0.3))
                    .background(Color("cardBackground"))
                    
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                    .zIndex(self.recto ? 0 : 1)
                
                Color.gray

                    .zIndex((89.7...90.3).contains(abs(currentAngle)) || (269.7...270.3).contains(abs(currentAngle)) ? 2 : 0)
                
                rectoView
                    .background(Color("cardBackground"))
                
            }
            //.frame(width: UIScreen.main.bounds.width * 100/100, height: UIScreen.main.bounds.height * 100/100)
                
            .cornerRadius(70)
            .shadow(color: Color.black.opacity(0.4), radius: abs(shadow), x: shadow, y:  abs(shadow))
            .rotation3DEffect(Angle(degrees: currentAngleMod) , axis: (x: 0, y: 1, z: 0), anchor: .center)
            .offset(x: currentPosition.width, y: currentPosition.height)
            .gesture(drag)
            .zIndex(1)
            
            ForEach(1..<3, id: \.self) {i in
                Color.gray


                .cornerRadius(70)
                    .rotation3DEffect(Angle(degrees: self.currentAngleMod) , axis: (x: 0, y: 1, z: 0), anchor: .center)
                    .offset(x: Int(self.currentAngle) % 180 == 0 ? self.currentPosition.width : (self.left ? self.currentPosition.width + CGFloat(2 * i) : self.currentPosition.width - CGFloat(2 * i)), y:  self.currentPosition.height)
                .zIndex(0)
            }
            

        }
        .frame(width: DeviceManager.cardWidth, height: DeviceManager.cardHeight)
    }
}



struct CardFlip_Previews: PreviewProvider {
    static var previews: some View {
        CardFlip(versoView: {
            CardVerso(card: Card())
        }, rectoView: {
            CardRecto(card: Card())
            
        })
    }
    
}
