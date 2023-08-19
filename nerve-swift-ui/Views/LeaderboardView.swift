//
//  LeaderboardView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 7/31/23.
//

import SwiftUI
import Amplify

func fetchCurrentAuthSession() async -> Bool {
    do {
        let session = try await Amplify.Auth.fetchAuthSession()
        print("Is user signed in - \(session.isSignedIn)")
        return session.isSignedIn
    } catch let error as AuthError {
        print("Fetch session failed with error \(error)")
        return false
    } catch {
        print("Unexpected error: \(error)")
        return false
    }
}

struct LeaderboardView: View {
    
    @State private var currentPage: String? = nil
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userData: UserData
    
    private var users: [LocalUser] {
        
        let currentUser = LocalUser(
            id: UUID(),
            name: userData.name,
            ranking: Int.random(in: 6...6),
            views: Int.random(in: 0...0),
            profilePic: getSavedImage(named: "profile.jpg") ?? UIImage(systemName: "person.crop.circle")!,
            change: "same"
        )
        
        //originally the line below said "var", but xcode said to change it to let
        let users = DummyUserData.testUsers + [currentUser]
        
        return users.sorted { $0.ranking < $1.ranking }
    }
    
    init()  {
      let navBarAppearance = UINavigationBar.appearance()
      navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
      navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    var body: some View {
        NavigationStack(path: $navModel.leaderboardPath) {
            if navModel.hasFinishedOnboarding {
                VStack {
                    List{
                        Image("prizes")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 200)
                            .padding(.bottom, 10)
                            .listRowBackground(Color.black)
                        ForEach(users){ user in
                            HStack{
                                VStack (spacing: 4) {
                                    Text(String("\(user.ranking)"))
                                    
                                    if user.ranking == 1 {
                                        Rectangle()
                                            .fill(Color(UIColor(red: 0.906, green: 0.737, blue: 0.333, alpha: 1)))
                                            .frame(width: 10, height: 2)
                                    } else if user.ranking == 2 {
                                        Rectangle()
                                            .fill(Color(UIColor(red: 0.753, green: 0.753, blue: 0.753, alpha: 1)))
                                            .frame(width: 10, height: 2)
                                    } else if user.ranking == 3 {
                                        Rectangle()
                                            .fill(Color(UIColor(red: 0.725, green: 0.447, blue: 0.176, alpha: 1)))
                                            .frame(width: 10, height: 2)
                                    }
                                    
                                }
                                if let profilePic = user.profilePic {
                                    Image(uiImage: profilePic)
                                        .resizable()
                                        .background(Color.white)
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(20)


                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(20)
                                }
                                VStack (alignment: .leading, spacing: 4){
                                    HStack {
                                        Text(user.name)
                                        switch user.change {
                                            case "up":
                                                Image("up")
                                            case "down":
                                                Image("down")
                                            default :
                                                Image("same")
                                        }
                                        
                                        Spacer()
                                        HStack (spacing: 2){
                                            Text(String(user.views))
                                            Image(systemName: "eye")
                                                .scaleEffect(0.7)
                                        }
                                    }
                                    Rectangle()
                                        .fill(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)))
                                        .frame(width: (CGFloat(user.views) * 0.4), height: 2)
                                }
                            }
                        }
                        .listRowBackground(Color.black)
                    }
                    .listStyle(PlainListStyle())
                }
                .background(Color.black)
                .navigationTitle("Leaderboard")
                .addProfileToolbar(pressedHandler: profilePressed)
                .foregroundColor(.white)
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
                        let transaction = Transaction()
                        withTransaction(transaction) {
                            navModel.isOnboarding = true
                        }
                    }
                    .fullScreenCover(isPresented: $navModel.isOnboarding) {
                        OnboardingView()
                    }
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    
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
        LeaderboardView().environmentObject(UserData()).environmentObject(NavigationModel())
    }
}






/*
 HStack (alignment: .bottom){
     Spacer()
     VStack {
         ZStack (alignment: .bottom){
             Text("$5,000")
                 .bold()
                 .foregroundColor(.white)
                 .font(.system(size: 15))
                 .padding(.bottom, 5)
         }
         ZStack (alignment: .bottom) {
             Rectangle()
                 .fill(Color(UIColor(red: 0.753, green: 0.753, blue: 0.753, alpha: 1)))
                 .frame(width: 70, height: 80)
             VStack {
                 Text("2nd")
                     .bold()
                     .foregroundColor(.white)
                     .font(.system(size: 20))
                 Text("Prize")
                     .bold()
                     .foregroundColor(.white)
                     .font(.system(size: 12))
                     .padding(.bottom, 20)
             }
         }
     }
     ZStack (alignment: .bottom){
         Rectangle()
             .fill(Color(UIColor(red: 0.906, green: 0.737, blue: 0.333, alpha: 1)))
             .frame(width: 70, height: 120)
         Text(String("1st\nPrize"))
             .foregroundColor(.white)
             .font(.system(size: 20))
     }
     ZStack (alignment: .bottom){
         Rectangle()
             .fill(Color(UIColor(red: 0.725, green: 0.447, blue: 0.176, alpha: 1)))
             .frame(width: 70, height: 40)
         Text(String("3rd\nPrize"))
             .foregroundColor(.white)
             .font(.system(size: 20))
     }
     Spacer()
 }
 .frame(maxWidth: .infinity, maxHeight: .infinity)
 .background(Color.blue)
 */





/*
 profile picture old pink stroke
 
 .border(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)), width: 1.0)
 .overlay(
         Circle()
             .stroke(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)), lineWidth: 1.3)
     )
 */
