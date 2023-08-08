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
            ZStack {
                Image("openingviewbig")
                VStack {
                    Text("By pressing 'Play' you're \naccepting the Terms.")
                        .font(.system(size: 10))
                        .foregroundColor(.gray.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.top, 350)
                        .padding(.bottom, 10)
                    
                    Button(action: getStartedButtonPressed) {
                        Text("Play")
                            .foregroundColor(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)))
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .monospaced()
                            .kerning(1.0)
                            .frame(width: 200)
                            .frame(height: 50)
                            .cornerRadius(10)
                            .background(
                                ZStack {
                                    Rectangle()
                                        .fill(Color.white)
                                        .cornerRadius(10)
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.3), Color.clear]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .mask(Rectangle().cornerRadius(10))
                                }
                            )
                    }
                    .border(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)), width: 2)
                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 4)
                    
                }
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
