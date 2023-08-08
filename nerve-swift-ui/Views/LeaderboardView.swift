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
            ranking: Int.random(in: 6...6),
            views: Int.random(in: 0...0),
            profilePic: getSavedImage(named: "profile.jpg") ?? UIImage(systemName: "person.crop.circle")!
        )
        
        //originally the line below said "var", but xcode said to change it to let
        let users = DummyUserData.testUsers + [currentUser]
        
        return users.sorted { $0.ranking < $1.ranking }
    }
    
    var body: some View {
        NavigationStack(path: $navModel.leaderboardPath) {
            if navModel.hasFinishedOnboarding {
                VStack {
                    List{
                        Image("yaleleaderboard")
                            .frame(width: 360, height: 180)
                            .padding(.top, 75)
                        ForEach(users){ user in
                            HStack{
                                Text(String("#\(user.ranking)"))
                                    .monospaced()
                                if let profilePic = user.profilePic {
                                    Image(uiImage: profilePic)
                                        .resizable()
                                        .background(Color.white)
                                        .frame(width: 40, height: 40)
                                        .border(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)), width: 1.0)
                                        .cornerRadius(20)
                                        .overlay(
                                                Circle()
                                                    .stroke(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)), lineWidth: 1.3)
                                            )
                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .border(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)), width: 1.0)
                                        .cornerRadius(20)
                                        .overlay(
                                                Circle()
                                                    .stroke(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)), lineWidth: 1.3)
                                            )

                                }
                                Text(user.name)
                                    .monospaced()
                                Spacer()
                                Text(String(user.views))
                                    .monospaced()
                                Image(systemName: "eye")
                                    .scaleEffect(0.7)
                            }
                            
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .navigationTitle("Yale Leaderboard")
                .addProfileToolbar(pressedHandler: profilePressed)
                .foregroundColor(.black)
                .navigationDestination(for: Screen.self) { screen in
                    switch screen {
                    case .profile: ProfilePageView()
                    default: Text("\(#function) need to add case for this view")
                        
                    }
                }
                
            }
            else
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
}

extension String: Identifiable {
    public var id: String {
        self
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView().environmentObject(NavigationModel())
    }
}
