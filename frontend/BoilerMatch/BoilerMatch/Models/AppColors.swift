//
//  AppColors.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import SwiftUI

struct AppColors {
    // App logo colors
    static let lightBeige = Color(hex: 0xE6D0B1)
    static let mediumBeige = Color(hex: 0xF1D9AD)
    static let darkBeige = Color(hex: 0xDEC597)
    static let lightestBeige = Color(hex: 0xFFEAD1)
    
    // Purdue branding colors
    static let boilermakerGold = Color(hex: 0xCFB991) // Primary gold
    static let black = Color(hex: 0x000000)          // Primary black
    static let agedGold = Color(hex: 0x8E6F3E)       // Supporting gold
    static let rushGold = Color(hex: 0xDAAA00)       // Vibrant gold
    static let coolGray = Color(hex: 0x6F727B)       // Supporting gray
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
