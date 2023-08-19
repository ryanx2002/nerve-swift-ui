//
//  TabViewContainer.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/3/23.
//

import SwiftUI

struct TabViewContainer: View {
    
    @EnvironmentObject var navModel: NavigationModel
    @State private var selection = 2
    
    var body: some View {
        TabView (selection: $selection){
                    
            PlayView()
                .tabItem {
                    Image (systemName: "gamecontroller.fill")
                }
                .tag(1)

            Spacer()
            
            LeaderboardView()
                .tabItem {
                    Image ("leaderboardbanner")
                }
                .tag(2)
            
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
