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
    @Published var hasFinishedOnboarding: Bool
    @Published var isOnboarding: Bool
    
    init() {
        let userDefaults = UserDefaults.standard
        self.leaderboardPath = NavigationPath()
        self.playPath = NavigationPath()
        self.hasFinishedOnboarding = userDefaults.bool(forKey:"hasFinishedOnboarding")
        self.isOnboarding = false
    }
}

@main
struct nerve_swift_uiApp: App {
    
    
    
    @StateObject var userData = UserData()
    @StateObject var navigationModel = NavigationModel()
    
    
    var body: some Scene {
        WindowGroup {
            TabViewContainer()
                .environmentObject(userData)
                .environmentObject(navigationModel)
            
        }
    }
}

