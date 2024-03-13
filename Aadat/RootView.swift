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
    case statsView
    case calendarView
}

class UserModel: ObservableObject {
    @Published var allTags: [String]
    @Published var showAllTasks: Bool = false
    
    init() { self.allTags = UserDefaults.standard.object(forKey:"allTags") as? [String] ?? ["No Tag"] }
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
    
    /* have to use this for toolbar.bottomBar coloring */
    // hex to uiColor https://www.uicolor.io
    let darkUIColor = UIColor(red: 0.03, green: 0.01, blue: 0.03, alpha: 1.00)
    init() {UIToolbar.appearance().barTintColor = darkUIColor}
    
    var body: some View {
        Group {
            switch rootViewManager.rootViewType {
                case .homeView:
                    HomeView()
                case .statsView:
                    StatsView()
                case .calendarView:
                    SessionsCalendarView()
                        .mainBackground()
            }
        }
        .environmentObject(rootViewManager)
        .environmentObject(userModel)
        .rootBottomNavBar(rootViewManager: rootViewManager)
        
        .onAppear {
            initAllTags()
            //speechRecognitionModel.startRecordingProcess()
        }
        .onChange(of: speechRecognitionModel.identifiedLanguage) {
            print("Going into updateSessions with identified language: \(speechRecognitionModel.identifiedLanguage)")
            updateSessions()
        }
    }
    
    private func updateSessions() {
        print("prev lang: \(speechRecognitionModel.lastAutomatedTaskLanguage)")
        
        let identifiedLanguage = speechRecognitionModel.identifiedLanguage.lowercased()
        let lastAutomatedTaskLanguage = speechRecognitionModel.lastAutomatedTaskLanguage.lowercased()
        
        if (speechRecognitionModel.lastAutomatedTaskLanguage.isEmpty) {
            for task in tasks {
                if (task.tag.lowercased() == identifiedLanguage) {
                    // if there's a task that matches the identified language then start that task automatically
                    speechRecognitionModel.lastAutomatedTaskLanguage = speechRecognitionModel.identifiedLanguage
                    let newSession = Session(startTime: Date.now)
                    newSession.tag = task.tag
                    newSession.isAutomatic = true
                    context.insert(newSession)
                    break
                }
            }
        } else if (!speechRecognitionModel.lastAutomatedTaskLanguage.isEmpty && (identifiedLanguage != lastAutomatedTaskLanguage)) {
            // if we already started a task automatically and the language we detect is not the same as that task
            print("going in")
            for session in sessions {
                if ((session.tag.lowercased() == lastAutomatedTaskLanguage) && session.isAutomatic) {
                    speechRecognitionModel.lastAutomatedTaskLanguage = ""
                    print("going in to end session")
                    session.endSession()
                    // call updateSessions again to potentially start a new automated task with the language that was just detected
                    updateSessions()
                    break
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
                            Image(systemName: "fitness.timer.fill")
                                .frame(maxWidth: .infinity)
                        }.standardToolbarButton()
                        
                        Button { /* Calendar View */
                            rootViewManager.rootViewType = .calendarView
                        } label: {
                            Image(systemName: "calendar")
                                .frame(maxWidth: .infinity)
                        }.standardToolbarButton()
                        
                        Button { /* Stats View */
                            rootViewManager.rootViewType = .statsView
                        } label: {
                            Image(systemName: "chart.bar.xaxis.ascending.badge.clock.rtl")
                                .frame(maxWidth: .infinity)
                        }.standardToolbarButton()
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
