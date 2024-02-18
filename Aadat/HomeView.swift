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
    
    var body: some View {
        VStack {
            PinnedView()
            
            SessionsView()
            
            AddTaskOrSessionView()
        }
        .environmentObject(userModel)
        .padding()
    }
}

#Preview {
    HomeView()
}
