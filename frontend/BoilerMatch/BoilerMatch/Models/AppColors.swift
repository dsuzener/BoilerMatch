//
//  AppColors.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import SwiftUI

struct AppColors {
    static let lightBeige = Color(hex: 0xE6D0B1)
    static let mediumBeige = Color(hex: 0xF1D9AD)
    static let darkBeige = Color(hex: 0xDEC597)
    static let lightestBeige = Color(hex: 0xFFEAD1)
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
