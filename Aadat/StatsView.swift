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
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                
                if sessions.count > 0 {
                    ChartView()
                } else {
                    Text("There are no active sessions!")
                        .fontWeight(.medium)
                        .padding(/*@START_MENU_TOKEN@*/.all, 20.0/*@END_MENU_TOKEN@*/)
                        .background(Color(hue: 0.58, saturation: 0.783, brightness: 0.456))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.063, green: 0.1803921568627451, blue: 0.2901960784313726)/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    StatsView()
}
