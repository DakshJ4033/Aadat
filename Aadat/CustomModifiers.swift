//
//  CustomModifiers.swift
//  Aadat
//
//  Created by Ako Tako on 2/22/24.
//

import Foundation
import SwiftUI

/* For general modifiers:
View specific modifiers may make
more sense to keep on their View file
Add more sections below */
let standardDarkHex = 0x422C42 // really dark purple
let standardLightHex = 0xEEDCF7 // white purple-pink
let standardBrightPinkHex = 0xC36AC0
let standardLightRedHex = 0xCB7C6B
let standardDarkGrayHex = 0x171717 // dark gray

/* hex extension */
extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

extension View {
    func mainBackground() -> some View {
        modifier(MainBackground())
    }
    func standardBoxBackground() -> some View {
        modifier(StandardBoxBackground())
    }
    func standardText() -> some View {
        modifier(StandardText())
    }
    func standardTitleText() -> some View {
        modifier(StandardTitleText())
    }
    func standardSubTitleText() -> some View {
        modifier(StandardSubTitleText())
    }
    func separatorLine() -> some View {
        modifier(SeparatorLine())
    }
    func standardEncapsulatingBox() -> some View {
        modifier(StandardEncapsulatingBox())
    }
    func standardToolbarButton() -> some View {
        modifier(StandardToolbarButton())
    }
    func standardPickerText() -> some View {
        modifier(StandardPickerText())
    }
    func defaultSheetDetents() -> some View {
        modifier(DefaultSheetDetents())
    }
}

struct MainBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(hex: standardDarkGrayHex))
    }
}
struct StandardBoxBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(hex: standardDarkHex))
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
    }
}
struct StandardText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(Color(hex: standardLightHex))
            .bold()
    }
}
struct StandardTitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(hex: standardLightHex))
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
struct StandardSubTitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(hex: standardLightHex))
            .font(.title3)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
struct SeparatorLine: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay( // "underline" under the TextField
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(Color(hex: standardLightHex))
                    .frame(height: 0.3) // makes a line instead of a "Block"
                    .padding(.top, 40) // padding to adjust distance from bottom
            )
    }
}
struct StandardEncapsulatingBox: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
    }
}
struct StandardToolbarButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(hex: standardBrightPinkHex)) // button color
            .buttonStyle(.borderless)
    }
}
struct StandardPickerText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .tint(Color(hex:standardLightHex))
    }
}

/* Modal Sheets */
struct DefaultSheetDetents: ViewModifier {
    func body(content: Content) -> some View {
        content
            .presentationDetents([.fraction(0.25), .medium])
    }
}

