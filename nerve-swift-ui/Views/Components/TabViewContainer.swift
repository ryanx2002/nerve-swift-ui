//
//  TabViewContainer.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/3/23.
//

import SwiftUI

struct TabViewContainer: View {
    
    @EnvironmentObject var navModel: NavigationModel
    
    var body: some View {
        TabView {
            PlayView()
                .tabItem {
                    Image (systemName: "gamecontroller.fill")
                    Text ("Play $$$")
                }
            LeaderboardView()
                .tabItem {
                    Image (systemName: "trophy")
                    Text ("Leaderboard")
                }
        }
        .toolbar {
            Text("Test")
        }
        .opacity(navModel.isOnboarding ? 0.0 : 1.0)
    }
}

struct TabViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabViewContainer()
    }
}
