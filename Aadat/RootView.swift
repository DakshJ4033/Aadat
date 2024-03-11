//
//  ContentView.swift
//  Aadat
//
//  Created by Daksh Jain on 2/15/24.
//
import AVFoundation
import Foundation
import Speech
import SwiftUI
import SwiftData
/* RootView Manager */
class RootViewManager: ObservableObject {
    @Published var rootViewType: RootViewType = .homeView
}

enum RootViewType {
    case homeView
    case manageTagsView
    case statsView
}

class UserModel: ObservableObject {
    @Published var allTags: [String]
    
    init() {
        self.allTags = UserDefaults.standard.object(forKey:"allTags") as? [String] ?? ["No Tag"]
    }
    
    func updateAllTags() {
        UserDefaults.standard.set(self.allTags, forKey: "allTags")
    }
}

struct RootView: View {
    @Query var sessions: [Session]
    @Query var tasks: [Task]
    @Environment(\.modelContext) var context
    @StateObject var rootViewManager: RootViewManager = RootViewManager()
    @StateObject var speechRecognitionModel = SpeechRecognitionModel(identifiedLanguage: "")
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
                
            case .statsView:
                StatsView()
                
            }
            // TODO: CalendarView()?
            
        }
        .environmentObject(rootViewManager)
        .environmentObject(userModel)
        .rootBottomNavBar(rootViewManager: rootViewManager)
        .onAppear {
            initAllTags()
            speechRecognitionModel.startRecordingProcess()
        }
        .onChange(of: speechRecognitionModel.identifiedLanguage) {
            print("Going into updateSessions with identified language: \(speechRecognitionModel.identifiedLanguage)")
            updateSessions()
        }
    }
    
    private func updateSessions() {
        print("prev lang: \(speechRecognitionModel.previousLanguage)")
        if (speechRecognitionModel.previousLanguage.isEmpty) {
            speechRecognitionModel.previousLanguage = speechRecognitionModel.identifiedLanguage
            for task in tasks {
                if (task.tag == speechRecognitionModel.previousLanguage) {
                    // if we have a session, but its endTime is not nil, then make a new session
                    let newSession = Session(startTime: Date.now)
                    newSession.tag = task.tag
                    newSession.isAutomatic = true
                    context.insert(newSession)
                }
            }
        } else if (!speechRecognitionModel.previousLanguage.isEmpty && speechRecognitionModel.identifiedLanguage != speechRecognitionModel.previousLanguage) {
            print("going in")
            for session in sessions {
                if session.tag == speechRecognitionModel.previousLanguage && session.isAutomatic {
                    print("going in to end session")
                    session.endSession()
                    speechRecognitionModel.previousLanguage = ""
                }
            }
        }
    }
    
    func initAllTags() {
        if tasks.count > 0 {
            for task in tasks {
                !userModel.allTags.contains(task.tag) ? userModel.allTags.append(task.tag) : print("dupe \(task.tag)")
            }
        } else {
            userModel.allTags = ["No Tag"]
        }
        
        userModel.allTags = Array(Set(userModel.allTags))
        UserDefaults.standard.set(userModel.allTags, forKey: "allTags")
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
                            Image(systemName: "tag.fill")
                        }
                        
                        Button { /* Stats View */
                            rootViewManager.rootViewType = .statsView
                        } label: {
                            Image(systemName: "chart.bar.xaxis.ascending.badge.clock.rtl")
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
