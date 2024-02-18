//
//  SessionView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI

struct SessionsView: View {
    
    @EnvironmentObject var userModel: UserModel

    var body: some View {
        VStack {
            /* Show completed sessions */
            Text("Completed Sessions")
        }
        .frame(maxWidth: .infinity)
        // TODO: make a better UI for this box
        .background(.blue)
        .padding()
    }
}

#Preview {
    SessionsView()
}
