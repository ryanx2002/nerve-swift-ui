//
//  VenmoView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/1/23.
//

import SwiftUI

struct VenmoView: View {
    
    @State private var venmoId = ""
    
    var body: some View {
        
        VStack {
        
            Text("Welcome, ")
                .padding(.top, 100)
                .padding(.bottom, 50)
            
            TextField("Venmo handle", text: $venmoId)
                .padding(.top, 50)
                .padding(.bottom, 50)
                .multilineTextAlignment(.center)
            
            NavigationLink (destination: ProfilePictureView()) {
                Text ("Next")
                    .foregroundColor(.white)
                .cornerRadius(5)
                .frame(width: 200)
                .frame(height: 50)
                .background(Color.pink)
                .padding(.top, 50)
                .padding(.bottom, 90)
                
            }
        }
    }
    
}

struct VenmoView_Previews: PreviewProvider {
    static var previews: some View {
        VenmoView()
    }
}
