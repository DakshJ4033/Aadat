//
//  HomeView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        ScrollView {
            VStack {
                
                if(userModel.showAllTasks) {
                    AllTasksView()
                } else {
                    PinnedView()
                }
                
                SessionsView()
                
                AddTaskOrSessionView()
            }
            
        }
        .mainBackground()
    }
}

#Preview {
    HomeView()
}
