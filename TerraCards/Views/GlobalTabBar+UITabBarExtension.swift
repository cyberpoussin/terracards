//
//  GlobalTabBar+UITabBarExtension.swift
//  TerraCards
//
//  Created by foxy on 03/06/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

struct GlobalTabBar {
    static var tabBar : UITabBar?
    
    static func toggle() {
        guard let tabBar = GlobalTabBar.tabBar else { return }
        print("on va la faire disp")
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
            if tabBar.alpha == 0 {
                tabBar.alpha = 1
            } else {
                tabBar.alpha = 0
            }
        }
        animator.startAnimation()
    }
    
    static func disappear() {
        guard let tabBar = GlobalTabBar.tabBar else { return }
        print("on va la faire disp")
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
                tabBar.alpha = 0
        }
        animator.startAnimation()
    }
    
    static func reAppear() {
        guard let tabBar = GlobalTabBar.tabBar else { return }
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
                tabBar.alpha = 1
        }
        animator.startAnimation()
    }
}
extension UITabBar {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        GlobalTabBar.tabBar = self
        print("Tab Bar moved to superview")
    }
    
    
}
