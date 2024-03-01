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
    }
}

#Preview {
    HomeView()
}
