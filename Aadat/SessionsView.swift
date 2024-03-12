//
//  SessionView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData

struct SessionsView: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @Environment(\.modelContext) var context
    @Query private var sessions: [Session]

    var body: some View {
        VStack {
            /* Show completed sessions */
            Text("Sessions").standardTitleText()
            if sessions.count != 0 {
                Section {
                    ForEach(sessions) { session in
                        SessionView(session: session)
                    }
                }
            } else {
                Spacer()
                Text("There are no recorded sessions!").standardText()
                Spacer()
            }
        }
        .standardEncapsulatingBox()
    }
    
    func delete(_ indexSet: IndexSet) {
        for i in indexSet {
            let session = sessions[i]
            context.delete(session)
        }
    }
}

#Preview {
    SessionsView()
}
