//
//  TestImage.swift
//  TerraCards
//
//  Created by foxy on 04/06/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct TestImage: View {
    var body: some View {
        VStack {
            VStack {
                Image("photoChene")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width:UIScreen.main.bounds.width, height: 100, alignment: .top)
                    .clipped()
                Spacer()

            }
            .frame(height: 600)
            Text("titre")
            Spacer()
        }
    }
}

struct TestImage_Previews: PreviewProvider {
    static var previews: some View {
        TestImage()
    }
}
