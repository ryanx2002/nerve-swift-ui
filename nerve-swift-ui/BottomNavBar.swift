//
//  BottomNavBar.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/8/23.
//

import SwiftUI

struct BottomNavBar: View {
    @State var isPlay = true
    
    var body: some View {
        VStack{
            Button {
                
            } label: {
                isPlay ? Text("Upload") : Text("Play")
            }
            HStack{
                Text("Insert Leaderboard")
            }
        }
    }
}

struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar()
    }
}
