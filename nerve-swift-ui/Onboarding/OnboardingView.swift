//
//  GetStartedView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 7/31/23.
//

import SwiftUI

enum Screen: Hashable {
    case phoneNumber, confirmationCode, name, venmo, profilePicture, leaderboard, profile
    
    var prompt: String? {
        switch self {
        case .phoneNumber: return "Enter your phone number"
        case .name: return "First and Last Name"
        case .venmo: return "Enter your Venmo to get paid"
        default: return nil
        }
    }
    
    var next: Screen? {
        switch self {
        case .phoneNumber: return .name
        case .name: return .venmo
        case .venmo: return .profilePicture
        case .profilePicture: return .leaderboard
        default: return nil
        }
    }
    
    var valueName: String? {
        switch self {
        case .phoneNumber: return "Phone Number"
        case .name: return "Name"
        case .venmo: return "Venmo"
        case .profilePicture: return "Profile Picture"
        case .leaderboard: return"leaderboard"
        default: return nil
        }
    }
}

struct OnboardingView: View {
    
    @EnvironmentObject var navModel: NavigationModel
    var body: some View {
        NavigationStack (path: $navModel.leaderboardPath) {
            VStack {
                
                Spacer()
                    .frame(height: 100)
                
                Text("Nerve")
                    .font(.system(size: 70))
                    .foregroundColor(Color.pink.opacity(0.65))
                    .bold()
                    .monospaced()
                    .kerning(10.0)
                    .shadow(color: Color.pink.opacity(0.65), radius: 10)
                
                Spacer()
                    .frame(height: 50)
                
                VStack {
                    HStack{
                        Image("Group 7")
                        Image("Group 8")
                    }
                    HStack{
                        Spacer()
                        Text ("Do a dare")
                        Spacer()
                        
                        VStack{
                            Text ("Earn $$$")
                            Text ("Get Famous")
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                    .frame(height: 50)
                
                Button(action: getStartedButtonPressed) {
                    Text("Play")
                        .foregroundColor(.pink.opacity(0.65))
                        .bold()
                        .shadow(color: Color.pink.opacity(0.65), radius: 10)
                        .cornerRadius(10)
                        .frame(width: 200)
                        .frame(height: 50)
                        .border(Color.pink)
                        .colorScheme(.light)
                        .shadow(color: Color.pink.opacity(0.95), radius: 20)
                }
                
                Spacer()
                
                Text("By tapping Play, you agree to our")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 10))
                Text("Terms of Service and Privacy Policy")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 10))
                
            }
            
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .phoneNumber, .confirmationCode, .name, .venmo:
                    OnboardingFormView(screen: screen)
                case .profilePicture: ProfilePictureView()
                case .leaderboard: LeaderboardView()
                case .profile: Text("Need to add profile case")
                }
                
            }
        }
    }
    
    func getStartedButtonPressed () {
        navModel.leaderboardPath.append(Screen.phoneNumber)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
