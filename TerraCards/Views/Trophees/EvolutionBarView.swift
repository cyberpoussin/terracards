//
//  EvolutionBar.swift
//  TerraCards
//
//  Created by MacBookGP on 11/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct EvolutionBar: View {
    
    let valeurMaxLigne:CGFloat = 170
    @State var valEvolutionBar:CGFloat = 60
    @State var contour:Color = .white
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .frame(width: valeurMaxLigne , height: 3.0)
                .foregroundColor(Color.gray)
                .opacity(0.2)
            Rectangle()
                .frame(width: valEvolutionBar, height: 3.0)
                .foregroundColor(contour.opacity(0.5))
        }
   }
}

struct EvolutionBar_Previews: PreviewProvider {
    static var previews: some View {
        EvolutionBar()
    }
}
