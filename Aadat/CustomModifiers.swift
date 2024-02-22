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

/* Modal Sheets */

struct DefaultSheetDetents: ViewModifier {
    func body(content: Content) -> some View {
        content
            .presentationDetents([.fraction(0.25), .medium])
    }
}

extension View {
    func defaultSheetDetents() -> some View {
        modifier(DefaultSheetDetents())
    }
}
