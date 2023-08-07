//
//  LeaderboardView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 7/31/23.
//

import SwiftUI

struct LeaderboardView: View {
    
    @State private var currentPage: String? = nil
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userData: UserData
    
    
    private var users: [User] {
        
        let currentUser = User(
            id: UUID(),
            name: userData.name,
            ranking: Int.random(in: 6...7),
            views: Int.random(in: 0...1),
            profilePic: getSavedImage(named: "profile.jpg") ?? UIImage(systemName: "person.circle")!
        )
        
        //originally the line below said "var", but xcode said to change it to let
        let users = User.testUsers + [currentUser]
        
        return users.sorted { $0.ranking < $1.ranking }
    }
    
    var body: some View {
        NavigationStack(path: $navModel.leaderboardPath) {
            if navModel.hasFinishedOnboarding {
                VStack{
                    
                    HStack {
                        Spacer()
                        Image(systemName: "building.2")
                        Image(systemName: "globe")
                    }
                    
                    
                    Image("yaleleaderboard")
                        .frame(width: 360, height: 180)
                        .padding(.top, 40)
                    
                    List{
                        ForEach(users){ user in
                            HStack{
                                Text(String(user.ranking))
                                if let profilePic = user.profilePic {
                                    Image(uiImage: profilePic)
                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
                                        .background(Color.white)
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(20)
                                } else {
                                    Image(systemName: "person")
                                        .resizable()
                                        .background(Color.gray)
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(20)
                                }
                                Text(user.name)
                                Spacer()
                                Text(String(user.views))
                                Image(systemName: "eye")
                            }
                            
                        }
                    }
                    
                    
//                    Button(action: playButtonPressed) {
//                        Text("This is part of the leaderboard screen, not tab bar")
//                            .foregroundColor(.black)
//                    }
//                    .navigationDestination(for: String.self) {viewText in
//                        Text(viewText)
//                    }
                }

                .navigationTitle("Yale Leaderboard")
                .addProfileToolbar(pressedHandler: profilePressed)
//                .toolbar {
//                    Button(action: profilePressed) {
//                        Image(systemName: "person")
//                            .background(Color.gray)
//                            .cornerRadius(20)
//                            .frame(width: 40, height: 40)
//                    }
//                }
                .navigationDestination(for: Screen.self) { screen in
                    switch screen {
                    case .profile: ProfilePageView()
                    default: Text("\(#function) need to add case for this view")

                    }
                }
//                    Button(action: {
//                        currentPage = "Profile"
//                    }) {
//                        Image(systemName: "person")
//                            .background(Color.gray)
//                            .cornerRadius(20)
//                            .frame(width: 40, height: 40)
//                    }
//                    .fullScreenCover(item: $currentPage) { page in
//                        if page == "Profile" {
//                            ProfilePageView()
//                        }
//                    }
            } else
            {
                Color.white
                    .onAppear {
                        var transaction = Transaction()
                        withTransaction(transaction) {
                            navModel.isOnboarding = true
                        }
                    }
                    .fullScreenCover(isPresented: $navModel.isOnboarding) {
                        OnboardingView()
                    }
            }
        }
    }
    
    func profilePressed() {
        navModel.leaderboardPath.append(Screen.profile)
    }
    
//    func playButtonPressed () {
//        navPath.append("random words")
//    }
    
}
extension String: Identifiable {
    public var id: String {
        self
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}



