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
    @EnvironmentObject var userModel: UserModel
    
    @State private var showAddTaskOrSessionSheet = false
    
    var body: some View {
        ScrollView {
            VStack {
                PinnedView()
                
                SessionsView()
                
                AddTaskOrSessionView(showAddTaskOrSessionSheet: $showAddTaskOrSessionSheet)
            }
            .sheet(isPresented: $showAddTaskOrSessionSheet, content: {
                TaskOrSessionFormView()
            })
        }
        .environmentObject(userModel)
        .padding()
    }
}

#Preview {
    HomeView()
}
