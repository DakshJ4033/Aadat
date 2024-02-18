//
//  ContentView.swift
//  Aadat
//
//  Created by Daksh Jain on 2/15/24.
//

import SwiftUI

/* RootView Manager */
class RootViewManager: ObservableObject {
    @Published var rootViewType: RootViewType = .homeView
}

enum RootViewType {
    case homeView
    case manageTagsView
}

class UserModel: ObservableObject {
    @Published var tasks: [Task] = []
    
}

struct RootView: View {
    
    @StateObject var rootViewManager: RootViewManager = RootViewManager()
    @StateObject var userModel: UserModel = UserModel()
    
    var body: some View {
        Group {
            switch rootViewManager.rootViewType {
                
            case .homeView:
                HomeView()
                
            case .manageTagsView:
                TabView {
                    ManageTagsView()
                }
                
            }
            // TODO: StatsView(), generate stats across different time frames, show habits etc.
            // TODO: CalendarView()?
            
        }
        .environmentObject(rootViewManager)
        .environmentObject(userModel)
        .bottomNavBar(rootViewManager: rootViewManager)
        
    }
}

#Preview {
    RootView()
}

struct BottomNavBar: ViewModifier {
    var rootViewManager: RootViewManager
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    HStack {
                        Button { /* Home Button */
                            rootViewManager.rootViewType = .homeView
                        } label: {
                            Image(systemName: "house.circle.fill")
                        }
                        
                        Button { /* All Tags View */
                            rootViewManager.rootViewType = .manageTagsView
                        } label: {
                            Image(systemName: "book.pages.fill")
                        }
                    }
                }
            }
    }
}

extension View {
    func bottomNavBar(rootViewManager: RootViewManager) -> some View {
        modifier(BottomNavBar(rootViewManager: rootViewManager))
    }
}
