//
//  ProfilePageView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/2/23.
//

import AVKit
import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

func getSavedImage(named: String) -> UIImage? {
    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
        return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
    }
    return nil
}



struct ProfilePageView: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var navModel: NavigationModel
    @State private var name: String = ""
    @State private var venmoHandle: String = ""
    
    @State private var animate = false
    @State private var likeAnimation = false
    @State private var isLiked = false
    private var duration: Double = 0.1
    
    func signOut () async {
        let result = await Amplify.Auth.signOut()
            guard let signOutResult = result as? AWSCognitoSignOutResult
            else {
                print("Signout failed")
                return
            }

            print("Local signout successful: \(signOutResult.signedOutLocally)")
            switch signOutResult {
            case .complete:
                // Sign Out completed fully and without errors.
                print("Signed out successfully")
                navModel.leaderboardPath.removeLast(navModel.leaderboardPath.count)
                navModel.isOnboarding = false
                navModel.hasFinishedOnboarding = false

            case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
                // Sign Out completed with some errors. User is signed out of the device.
                
                if let hostedUIError = hostedUIError {
                    print("HostedUI error  \(String(describing: hostedUIError))")
                }

                if let globalSignOutError = globalSignOutError {
                    // Optional: Use escape hatch to retry revocation of globalSignOutError.accessToken.
                        print("GlobalSignOut error  \(String(describing: globalSignOutError))")
                }

                if let revokeTokenError = revokeTokenError {
                    // Optional: Use escape hatch to retry revocation of revokeTokenError.accessToken.
                    print("Revoke token error  \(String(describing: revokeTokenError))")
                }

            case .failed(let error):
                // Sign Out failed with an exception, leaving the user signed in.
                print("SignOut failed with \(error)")
            }
    }

    
    func performAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
            likeAnimation = false
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack {
                        Image(uiImage: getSavedImage(named: "profile.jpg") ?? UIImage(systemName: "person.crop.circle")!)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                        Text("\(userData.name)")
                            .padding(.bottom, 50)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(Color.white)
                    }
                    .padding(.trailing, 40)
                    VStack{
                        
                        HStack{
                            VStack (spacing: -1) {
                                HStack {
                                    Text("#")
                                        .bold()
                                        .foregroundColor(Color.white)
                                    switch userData.change {
                                    case "up":
                                        Image("up")
                                    case "down":
                                        Image("down")
                                    default :
                                        Image("same")
                                    }
                                }
                                Text("Rank")
                                    .foregroundColor(Color.white)
                            }
                            .padding(.trailing, 10)
                            .padding(.bottom, 50)
                            
                            VStack {
                                Text("3.4K")
                                    .bold()
                                    .foregroundColor(Color.white)
                                Text("Views")
                                    .foregroundColor(Color.white)
                            }
                            .padding(.trailing, 10)
                            .padding(.bottom, 50)
                            
                            VStack{
                                Text("$0")
                                    .bold()
                                    .foregroundColor(Color.white)
                                Text("Earned")
                                    .foregroundColor(Color.white)
                            }
                            .padding(.bottom, 50)
                        }
                        Button { Task { await signOut() }} label: {Text("Sign out")}
                    }
                }
                HStack{
                    Text("Streak a field")
                        .bold()
                        .foregroundColor(Color.white)
                        .padding(.leading, 10)
                    Text("| $200")
                        .foregroundColor(Color.white)
                    Spacer()
                }
                VideoPlayer(player: AVPlayer(url: URL.documentsDirectory.appending(component: "movie.mp4")))
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                HStack {
                    Button (action: {
                        self.animate = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.duration, execute: {
                            self.animate = false
                            self.isLiked.toggle()
                        })
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .white)
                            .frame(width: 18, height: 18)
                    }
                        .padding(.leading, 10)
                        .animation(.easeIn (duration: duration))
                    Image(systemName: "bubble.right")
                        .foregroundColor(.white)
                        .frame(width: 18, height: 18)
                    Spacer()
                    Text("0")
                        .foregroundColor(Color.white)
                    Image(systemName: "eye")
                        .foregroundColor(Color.white)
                        .scaleEffect(0.7)
                        .padding(.trailing, 10)
                }
            }
            .padding(.top, -20)
        }
        .background(Color.gray)
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView().environmentObject(UserData())
    }
}

struct ProfileToolbar: ViewModifier {
    
    var pressedHandler: () -> Void
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                Button(action: pressedHandler) {
                    Image(systemName: "person")
                        .background(Color.gray)
                        .cornerRadius(20)
                        .frame(width: 40, height: 40)
                }
            }
    }
}

extension View {
    func addProfileToolbar(pressedHandler: @escaping () -> Void) -> some View {
        //        modifier(Watermark(text: text))
        modifier(ProfileToolbar(pressedHandler: pressedHandler))
    }
}
