//
//  nerve_swift_uiApp.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 7/31/23.
//

import SwiftUI
import Amplify
import AWSDataStorePlugin
import AWSCognitoAuthPlugin
import AWSAPIPlugin

class NavigationModel: ObservableObject {
    
    @Published var leaderboardPath: NavigationPath
    @Published var playPath: NavigationPath
    @Published var hasFinishedOnboarding: Bool
    @Published var isOnboarding: Bool
    
    init() {
        self.leaderboardPath = NavigationPath()
        self.playPath = NavigationPath()
        self.hasFinishedOnboarding = false
        self.isOnboarding = false
    }
}

func configureAmplify() {
    let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
    do {
        try Amplify.add(plugin: dataStorePlugin)
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.add(plugin: AWSAPIPlugin())
        try Amplify.configure()
        print("Initialized Amplify");
    } catch {
        // simplified error handling for the tutorial
        print("Could not initialize Amplify: \(error)")
    }
}

@main
struct nerve_swift_uiApp: App {
    
    @StateObject var userData = UserData()
    @StateObject var navigationModel = NavigationModel()
    
    init() {
        configureAmplify()
    }
    
    
    var body: some Scene {
        WindowGroup {
            TabViewContainer()
                .environmentObject(userData)
                .environmentObject(navigationModel)
            
        }
    }
}

