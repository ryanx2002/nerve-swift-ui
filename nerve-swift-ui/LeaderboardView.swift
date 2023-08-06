//
//  LeaderboardView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 7/31/23.
//

import SwiftUI

struct LeaderboardView: View {
    
    @State private var currentPage: String? = nil
    @State private var users = User.testUsers
    @EnvironmentObject var navModel: NavigationModel
    
    
    var body: some View {
        NavigationStack(path: $navModel.leaderboardPath) {
            if navModel.hasFinishedOnboarding {
                VStack{
                    List{
                        ForEach(users){ user in
                            HStack{
                                Text(String(user.ranking))
                                Image(systemName: "person")
                                    .background(Color.gray)
                                    .cornerRadius(20)
                                    .frame(width: 40, height: 40)
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

                .navigationTitle("Leaderboard")
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
            } else {
                Color.white
                    .onAppear {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
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


struct User: Identifiable {
    let id: UUID
    let name: String
    let ranking: Int
    let views: Int
    let profilePic: String
    
    static let testUsers = [
        User (id: UUID(), name: "Alex Holdings", ranking: 1, views: 69000, profilePic: ""),
        User (id: UUID(), name: "Kate Willimas", ranking: 2, views: 58000, profilePic: ""),

    ]
    
}
