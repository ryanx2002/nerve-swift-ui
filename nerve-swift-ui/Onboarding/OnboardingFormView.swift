//
//  PhoneNumber.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 7/31/23.
//

import SwiftUI

struct OnboardingFormView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var userData: UserData
    
    @State private var phoneNumber = ""
    var screen: Screen
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(screen.prompt!)
                .font(.system(size: 20))
                .foregroundColor(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)))
                .bold()
                .monospaced()
                .kerning(1.0)
                .shadow(color: Color.pink.opacity(0.65), radius: 10)
            
            TextField(screen.valueName!, text: binding())
                .padding(.top, 50)
                .padding(.bottom, 50)
                .multilineTextAlignment(.center)
            //                .keyboardType(.phonePad)
            
            Button(action: nextButtonPressed) {
                Text ("Next")
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
            .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 4)
            
            Spacer()
            
        }
        .background(Color(UIColor(red: 0.988, green: 0.965, blue: 0.953, alpha: 1)))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.pink)
        }
        )
    }
    
    func nextButtonPressed () {
        navigationModel.leaderboardPath.append(screen.next!)
    }
    
    func binding() -> Binding<String> {
        print("screen", screen)
        switch screen {
        case .name:
            return $userData.name
        case .phoneNumber:
            return $userData.phoneNumber
        case .venmo:
            return $userData.venmo
        default: return Binding(get: { "empty" }, set: { _ in })
        }
    }
}

struct OnboardingFormView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFormView(screen: .name)
    }
}
