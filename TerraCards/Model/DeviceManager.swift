//
//  DeviceManager.swift
//  TerraCards
//
//  Created by foxy on 30/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import SwiftUI

import Combine

enum DeviceType: String, CaseIterable {
    case iPhone8, iPhone8plus, iPhoneX, iPhoneXmax, iPadAir, iPad, iPad7, iPadPro11, iPadPro13, unknown
    
    var size: CGSize {
        switch self {
        case .iPhone8: return CGSize(width: 375, height: 667)
        case .iPhone8plus: return CGSize(width: 414, height: 736)
        case .iPhoneX: return CGSize(width: 375, height: 812)
        case .iPhoneXmax: return CGSize(width: 414, height: 896)
        
        case .iPad: return CGSize(width: 768, height: 1024)
        case .iPadAir: return CGSize(width: 834, height: 1112)
        case .iPad7: return CGSize(width: 810, height: 1080)
        case .iPadPro11: return CGSize(width: 834, height: 1194)
        case .iPadPro13: return CGSize(width: 1024, height: 1366)
            
        case .unknown: return CGSize(width: 375, height: 667)

        }
    }
}

enum OrientationType {
    case landscape, portrait
}

class DeviceManager {
    
    static var orientation: OrientationType {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        if width < height {
            return .portrait
        } else {
            return .landscape
        }
    }
    
    static var device: DeviceType {
        var width = UIScreen.main.bounds.width
        var height = UIScreen.main.bounds.height
        if orientation == .landscape {
            height = UIScreen.main.bounds.width
            width = UIScreen.main.bounds.height
        }
        let size = CGSize(width: width, height: height)
        if let device = DeviceType.allCases.first(where: {$0.size == size}) {
            print("vous utilisez un \(device.rawValue)")
            return device
        }
        
        return .unknown
    }
    
    static var isAnIphone: Bool {
        switch device {
        case .iPhone8, .iPhone8plus, .iPhoneX, .iPhoneXmax : return true
        default: return false
        }
    }
    
    static var cardSize: CGSize {
        switch orientation {
            
        case .landscape:
            switch device {
                case .iPhone8: return CGSize(width: 350, height: 300)
                case .iPhone8plus: return CGSize(width: 350, height: 350)
                case .iPhoneX: return CGSize(width: 375, height: 300)
                case .iPhoneXmax: return CGSize(width: 414, height: 350)
                    
                case .iPad: return CGSize(width: 500, height: 700)
                case .iPadAir: return CGSize(width: 500, height: 700)
                case .iPad7: return CGSize(width: 500, height: 700)
                case .iPadPro11: return CGSize(width: 500, height: 700)
                case .iPadPro13: return CGSize(width: 500, height: 700)
                    
                case .unknown: return CGSize(width: 350, height: 300)
            }

            
        case .portrait:
            switch device {
               case .iPhone8: return CGSize(width: 412, height: 412*1.7)
            case .iPhone8plus: return CGSize(width: 455, height: 455*1.7)
                case .iPhoneX: return CGSize(width: 412, height: 412*1.868)
                case .iPhoneXmax: return CGSize(width: 455, height: 455*1.868)
                    
                case .iPad: return CGSize(width: 500, height: 700)
                case .iPadAir: return CGSize(width: 500, height: 700)
                case .iPad7: return CGSize(width: 500, height: 700)
                case .iPadPro11: return CGSize(width: 500, height: 700)
                case .iPadPro13: return CGSize(width: 500, height: 700)
                    
                case .unknown: return CGSize(width: 350, height: 600)
            }
        }
    }
    static var cardWidth: CGFloat {
        self.cardSize.width
    }
    
    static var cardHeight: CGFloat {
        self.cardSize.height
    }
    
    static var miniCardScale: CGFloat {
        if orientation == .portrait && isAnIphone {
            return 0.25
        } else {
            return 0.5
        }
    }
    
}
