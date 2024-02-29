//
//  StatsView.swift
//  Aadat
//
//  Created by Ako Tako on 2/27/24.
//

import Foundation
import SwiftUI
import SwiftData

struct StatsView: View {
    
    @Query private var sessions: [Session]

    var body: some View {
        ScrollView {
            VStack {
                Text("Stats")
                ChartView()
            }
        }
        .padding()
    }
}

#Preview {
    StatsView()
}
