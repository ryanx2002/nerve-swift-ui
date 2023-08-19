//
//  GetStartedView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 7/31/23.
//

import SwiftUI

enum Screen: Hashable {
    case phoneNumber, confirmationCode, email, password, name, venmo, profilePicture, leaderboard, profile
    
    var prompt: String? {
        switch self {
        case .phoneNumber: return "Enter your phone number"
        case .email: return "Enter your email"
        case .password: return "Enter a password"
        case .confirmationCode: return "Enter the confirmation code from your email"
        case .name: return "First and Last Name"
        case .venmo: return "Enter your Venmo to get paid"
        default: return nil
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .phoneNumber: return UIKeyboardType.phonePad
        case .email: return UIKeyboardType.emailAddress
        case .name: return UIKeyboardType.namePhonePad
        default: return UIKeyboardType.default
        }
    }
    
    var textType: UITextContentType? {
        switch self {
        case .phoneNumber: return UITextContentType.telephoneNumber
        case .email: return UITextContentType.emailAddress
        case .confirmationCode: return UITextContentType.oneTimeCode
        case .password: return UITextContentType.password
        case .name: return UITextContentType.name
        default: return nil
        }
    }
    
    var next: Screen? {
        switch self {
        case .phoneNumber: return .email
        case .email: return .password
        case .password: return .confirmationCode
        case .confirmationCode: return .name
        case .name: return .venmo
        case .venmo: return .profilePicture
        case .profilePicture: return .leaderboard
        default: return nil
        }
    }
    
    var valueName: String? {
        switch self {
        case .phoneNumber: return "Phone Number"
        case .email: return "Email"
        case .password: return "Password"
        case .confirmationCode: return "Confirmation Code"
        case .name: return "Name"
        case .venmo: return "Venmo"
        case .profilePicture: return "Profile Picture"
        case .leaderboard: return "leaderboard"
        default: return nil
        }
    }
}

struct OnboardingView: View {
    
    let nervePink = UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)
    
    @EnvironmentObject var navModel: NavigationModel
    var body: some View {
        NavigationStack (path: $navModel.leaderboardPath) {
            ZStack {
                Image("openingviewbig")
                VStack {
                    Text("By pressing 'Play' you're \naccepting the Terms.")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.top, 350)
                        .padding(.bottom, 10)
                    
                    Button(action: getStartedButtonPressed) {
                        Text ("Play")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                            .glowBorder(color: Color(nervePink), lineWidth: 2)
                            .kerning(2.0)
                            .shadow(color: Color(nervePink).opacity(0.5), radius: 5)
                            .frame(width: 120)
                            .frame(height: 50)
                            .background(
                                Rectangle()
                                    .fill(Color.white.opacity(0.0))
                            )
                    }
                    .border(Color(nervePink), width: 1)
                    .padding(1.0)
                    .border(Color.white, width: 1)
                    .padding(1.0)
                    .border(Color(nervePink), width: 1)
                    .glowBorder(color: Color(nervePink), lineWidth: 1)
                    .shadow(color: Color(nervePink).opacity(0.5), radius: 5)
                    
                }
            }
            
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .phoneNumber, .confirmationCode, .email, .password , .name, .venmo:
                    OnboardingFormView(screen: screen)
                case .profilePicture: ProfilePictureView()
                case .leaderboard: LeaderboardView()
                case .profile: Text("Need to add profile case")
                }
                
            }
        }
    }
    
    func getStartedButtonPressed () {
        navModel.leaderboardPath.append(Screen.email)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
