//
//  SessionView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI

struct SessionView: View {
    var session: Session
    
    @State private var showAccountsPopOver: Bool = false
    var body: some View {
        HStack {
            Text("\(session.tag)")
                .lineLimit(1)
            Text("Started: \(session.getStartTime())")
        }
        .padding()
        .background(.gray)
        .onTapGesture {
            showAccountsPopOver = true;
        }
        .popover(isPresented: $showAccountsPopOver) {
            SessionDetailedView(session: session)
        }
    }
}

#Preview {
    SessionView(session: Session(startTime: Date.now))
}
