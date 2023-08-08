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
                }

            Spacer()
            
            LeaderboardView()
                .tabItem {
                    Image ("leaderboardbanner")
                }
            
            Spacer()
        }
        .accentColor(.white)
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
