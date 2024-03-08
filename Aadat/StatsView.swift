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
                Text("Statistics")
                    .foregroundStyle(.white)
                ChartView()
                
            }
            
        }
        .padding()
        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.063, green: 0.1803921568627451, blue: 0.2901960784313726)/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    StatsView()
}
