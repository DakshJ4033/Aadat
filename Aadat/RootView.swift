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
    @Published var sessions: [Session] = []
    
    @Published var defaultNoTagStr: String // used in the TaskView PICKER, beware refactor bugs
    @Published var allTags: [String]
    
    // TODO: this init may cause issues depending when we pull from disk
    init(defaultNoTagStr: String) {
        self.defaultNoTagStr = defaultNoTagStr
        self.allTags = [defaultNoTagStr]
    }
}

struct RootView: View {
    
    @StateObject var rootViewManager: RootViewManager = RootViewManager()
    @StateObject var userModel: UserModel = UserModel(defaultNoTagStr: "No tag")
    
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
        .rootBottomNavBar(rootViewManager: rootViewManager)
    }
}

struct RootBottomNavBar: ViewModifier {
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
    func rootBottomNavBar(rootViewManager: RootViewManager) -> some View {
        modifier(RootBottomNavBar(rootViewManager: rootViewManager))
    }
}

#Preview {
    RootView()
}
