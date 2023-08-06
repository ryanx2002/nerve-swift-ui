//
//  nerve_swift_uiApp.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 7/31/23.
//

import SwiftUI

class NavigationModel: ObservableObject {
    
    @Published var leaderboardPath: NavigationPath
    @Published var playPath: NavigationPath
    @Published var isOnboarding: Bool
    @Published var hasFinishedOnboarding: Bool
    
    init() {
        self.leaderboardPath = NavigationPath()
        self.playPath = NavigationPath()
        self.isOnboarding = false
        self.hasFinishedOnboarding = false
    }
}

@main
struct nerve_swift_uiApp: App {
    
    @StateObject var userData = UserData()
    @StateObject var navigationModel = NavigationModel()
    
    
    var body: some Scene {
        WindowGroup {
            TabViewContainer()
//            OnboardingView()
                .environmentObject(userData)
                .environmentObject(navigationModel)
            
        }
    }
}

