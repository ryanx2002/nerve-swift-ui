//
//  PhoneNumber.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 7/31/23.
//

import SwiftUI

struct PhoneNumberView: View {

    @Environment(\.presentationMode) var presentationMode
    @State private var phoneNumber = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Enter your phone number")
                    .padding(.top, 100)
                    .padding(.bottom, 50)
                
                TextField("Phone Number", text: $phoneNumber)
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.phonePad)
                
                NavigationLink (destination: ConfirmationCodeView()) {
                    Text ("Next")
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .frame(width: 200)
                        .frame(height: 50)
                        .background(Color.pink)
                        .padding(.top, 50)
                        .padding(.bottom, 100)
                    
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
    }
    
//    func nextButtonPressed () {
//         navPath.append(Screen.confirmationCode)
//    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
    }
}
