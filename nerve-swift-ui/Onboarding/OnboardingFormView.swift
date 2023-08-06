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
            Text(screen.prompt!)
                .font(.system(size: 20))
                .foregroundColor(Color.pink.opacity(0.65))
                .bold()
                .monospaced()
                .kerning(1.0)
                .shadow(color: Color.pink.opacity(0.65), radius: 10)
            
            TextField(screen.valueName!, text: binding())
                .padding(.top, 50)
                .padding(.bottom, 50)
                .multilineTextAlignment(.center)
                .keyboardType(.phonePad)
            
            Button(action: nextButtonPressed) {
                Text ("Next")
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
        }
        
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
            
        case .confirmationCode:
            return $userData.confirmationCode
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
