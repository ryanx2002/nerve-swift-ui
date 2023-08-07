//
//  ProfilePageView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/2/23.
//

import AVKit
import SwiftUI

func getSavedImage(named: String) -> UIImage? {
    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
        return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
    }
    return nil
}

func logOut() {
    UserDefaults.standard.set(false, forKey: "onboardingCompleted")
}

struct ProfilePageView: View {
    
    @EnvironmentObject var userData: UserData
    @State private var name: String = ""
    @State private var venmoHandle: String = ""
    //    @State private var profilePicture: Image?
    /*
     var movieURLs: [URL] {
     
     let userDirectoryURL = URL.documentsDirectory.appending(component: "movie.mp4")
     
     guard FileManager.default.fileExists(atPath: userDirectoryURL.path()) else {
     print(#function, "user directory does not exist")
     return []
     }
     
     do {
     let contents = try FileManager.default.contentsOfDirectory(atPath: userDirectoryURL.path())
     return contents.filter { $0.contains("movie") }
     .map { URL(fileURLWithPath: $0) }
     } catch {
     print(#function, "failed to get contents of directory", error)
     return []
     }
     }*/
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: getSavedImage(named: "profile.jpg") ?? UIImage(systemName: "person.circle")!)
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
                    UserDefaults.resetStandardUserDefaults()
                } label: {
                Text("Log Out")
            }
                
                /*Button {
                 
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
                 .padding(.bottom, 100)*/
                
                
                Text("Dares go here")
                
                VideoPlayer(player: AVPlayer(url: URL.documentsDirectory.appending(component: "movie.mp4")))
                    .scaledToFit()
                    .frame(width: 300, height: 300)
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
