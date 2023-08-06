//
//  ProfilePageView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/2/23.
//

import SwiftUI

struct ProfilePageView: View {
    
    @EnvironmentObject var userData: UserData
    @State private var name: String = ""
    @State private var venmoHandle: String = ""
//    @State private var profilePicture: Image?
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: userData.profileImage ?? UIImage(systemName: "person.circle")!)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.top, 100)
                    .padding(.bottom, 50)
                
                
                
                Text("Name: \(userData.name)")
                    .padding(.top, 100)
                    .padding(.bottom, 50)
                
                HStack {
                    Spacer()
                    
                    VStack{
                        Image(systemName: "building")
                        Text("#6")
                        Text("school Rank")
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "eye")
                        Text("3.4K")
                        Text("Views")
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 10)
                
                Button {
                    
                } label: {
                    Text("Edit Profile")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .frame(width: 200, height: 30)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                }
                .padding(.bottom, 100)
                
                
                Text("Dares go here")
            }
            .background(Color.red)
        }
        .addProfileToolbar {
            print("toolbar button pressed", #file)
        }
//        .toolbar {
//            Button(action: {}) {
//                Image(systemName: "person")
//                    .background(Color.gray)
//                    .cornerRadius(20)
//                    .frame(width: 40, height: 40)
//            }
//        }
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
