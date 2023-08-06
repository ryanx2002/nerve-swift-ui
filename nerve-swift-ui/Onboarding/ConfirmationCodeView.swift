//
//  ConfirmationCode.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 7/31/23.
//

import SwiftUI

struct ConfirmationCodeView: View {
    
    @EnvironmentObject var navModel: NavigationModel
    @State private var confirmationCode = ""
    
    var body: some View {
        
        VStack {
            Text("Enter the confirmation code")
                .padding(.top, 100)
                .padding(.bottom, 50)
            
            TextField("Confirmation Code", text: $confirmationCode)
                .padding(.top, 50)
                .padding(.bottom, 50)
            
            Button (action: nextButtonPressed) {
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
            
//            NavigationLink (destination: NameView()) {
//                Text ("Next")
//                    .foregroundColor(.white)
//                .cornerRadius(5)
//                .frame(width: 200)
//                .frame(height: 50)
//                .background(Color.pink)
//                .padding(.top, 50)
//                .padding(.bottom, 100)
//                
//            }
        }
        
        .navigationDestination(for: Screen.self) { screen in
            NameView()
        }
        
    }
    
    func nextButtonPressed () {
        navModel.leaderboardPath.append(Screen.name)
    }
}

struct ConfirmationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationCodeView()
    }
}
