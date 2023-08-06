//
//  NameView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/1/23.
//


import SwiftUI
import Combine

struct NameView: View {
    
    @EnvironmentObject var userData: UserData
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("First and Last Name")
                    .padding(.top, 100)
                    .padding(.bottom, 50)
                
                TextField("First and Last Name", text: $name)
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                
                NavigationLink (destination: VenmoView()) {
                    Text ("Next")
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .frame(width: 200)
                        .frame(height: 50)
                        .background(Color.pink)
                        .padding(.top, 50)
                        .padding(.bottom, 100)
                }
                .simultaneousGesture (
                    TapGesture().onEnded{
                        userData.name = name
                        print(userData.name)
                        
                    }
                )
            }
        }
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView()
    }
}
