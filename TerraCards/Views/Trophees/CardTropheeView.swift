//
//  CardTropheeView.swift
//  TerraCards
//
//  Created by MacBookGP on 12/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct CardTropheeView: View {
    
    @State var image:String
    @State var contour:Color
    var saturation: Double {
        switch self.contour {
        case .gold: return 1
        case .black: return 0.7
        case .green: return 0.4
        case .gray: return 0.2
        default: return 0
        }
    }
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.colorTrophees.opacity(0.05))
                .shadow(color: self.contour.opacity(0.06), radius: 7, x: 4, y: 4)
                .shadow(color: Color.white.opacity(0.2), radius: 8, x: -6, y: -6)
            //            .overlay(
            //                RoundedRectangle(cornerRadius: 15)
            //                .fill(Color.white)
            //                //    .frame(width: 200, height: 200)
            //                    .shadow(color: self.contour.opacity(0.2), radius: 10, x: 1, y: 1)
            //
            //                .shadow(color: self.contour.opacity(0.2), radius: 10, x: -1, y: -1)
            //
            //
            //            )
            //RoundedRectangle(cornerRadius: 15)
            
            Image(self.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                //.background(Color.white)
                .frame(width: 50, height: 50)
            //.saturation(self.saturation)
        }.frame(width: 60, height: 60)
        
        
        
        
    }
}

struct CardTropheeView_Previews: PreviewProvider {
    static var previews: some View {
        CardTropheeView(image: "test", contour: Color.black)
    }
}
