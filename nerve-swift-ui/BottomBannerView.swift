//
//  BottomBannerView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/3/23.
//



// THIS IS AN EXTRA / OLD VIEW THAT IS NOT USED ANYMORE



import SwiftUI

struct BottomBannerView: View {
    var body: some View {
        TabView {
            Text("Play")
                .tabItem {
                    Image (systemName: "play.rectangle")
                    Text ("Play")
                }
            
            LeaderboardView()
                .tabItem {
                    Image (systemName: "trophy")
                }
        }
        .accentColor(.pink.opacity(0.65))
    
    }
}

struct BottomBannerView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBannerView()
    }
}
