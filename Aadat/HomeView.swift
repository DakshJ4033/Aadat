//
//  HomeView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var rootViewManager: RootViewManager
    @State var showAllTasks: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                
                Toggle("Show All Tasks?", isOn: $showAllTasks)
                    .padding(20)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.6509803921568628, green: 0.5098039215686274, blue: 1.0)/*@END_MENU_TOKEN@*/)
                    .cornerRadius(10)
                
                
                if(showAllTasks) {
                    AllTasksView()
                } else {
                    PinnedView()
                }
                
                SessionsView()
                
                AddTaskOrSessionView()
                
                LanguageIdentifierView()
            }
            
        }
//        .environmentObject(userModel)
        .padding()
        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.063, green: 0.1803921568627451, blue: 0.2901960784313726)/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HomeView()
}
