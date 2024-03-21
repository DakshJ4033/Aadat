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
    @EnvironmentObject var userModel: UserModel
    @Query private var sessions: [Session]
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .standardTitleText()
                }
                
                if sessions.count > 0 {
                    ChartView()
                } else {
                    Text("You have no previous sessions history!")
                        .fontWeight(.medium)
                        .padding(/*@START_MENU_TOKEN@*/.all, 20.0/*@END_MENU_TOKEN@*/)
                        .background(Color(hex: standardDarkHex))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: standardDarkGrayHex))
    }
}

#Preview {
    StatsView()
}
