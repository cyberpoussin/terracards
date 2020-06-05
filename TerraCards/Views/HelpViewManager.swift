//
//  HelpViewManager.swift
//  TerraCards
//
//  Created by foxy on 04/06/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

class HelpViewManager: ObservableObject {
    @Published var offset = Array(repeating: CGSize(width: 0, height: 0), count: 4)
    
    @Published var showed = Array(repeating: false, count: 4)
    @Published var sheet = 0
    @Published var endFlip = false
    @Published var opacity = 0.1
    
    @Published var changeItemSelection: Int = 1 {
        didSet {
           reinit()
        }
    }
    
    func reinit() {
        self.offset = Array(repeating: CGSize(width: 0, height: 0), count: 4)
        
        self.showed = Array(repeating: false, count: 4)
        self.sheet = 0
        self.endFlip = false
        self.opacity = 0.1
    }
    
}
