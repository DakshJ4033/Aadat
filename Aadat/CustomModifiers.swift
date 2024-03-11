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
    func separatorLine() -> some View {
        modifier(SeparatorLine())
    }
    func standardEncapsulatingBox() -> some View {
        modifier(StandardEncapsulatingBox())
    }
    func standardToolbarButton() -> some View {
        modifier(StandardToolbarButton())
    }
    
    func defaultSheetDetents() -> some View {
        modifier(DefaultSheetDetents())
    }
}

struct MainBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(hex: 0x070308))
    }
}
struct StandardBoxBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(hex: 0x18101F)) // really dark purple
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
    }
}
struct StandardText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(Color(hex: 0xEEDCF7)) // white-purple/pink
            .bold()
    }
}
struct StandardTitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(hex: 0xEEDCF7)) // white-purple/pink
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
struct SeparatorLine: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay( // "underline" under the TextField
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(Color(hex: 0xEEDCF7))
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
            .foregroundStyle(Color(hex: 0xEEDCF7)) // white-purple/pink
            .buttonStyle(.borderless)
    }
}

/* Modal Sheets */
struct DefaultSheetDetents: ViewModifier {
    func body(content: Content) -> some View {
        content
            .presentationDetents([.fraction(0.25), .medium])
    }
}

