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

struct ProfilePageView: View {
    
    @EnvironmentObject var userData: UserData
    @State private var name: String = ""
    @State private var venmoHandle: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: getSavedImage(named: "profile.jpg") ?? UIImage(systemName: "person.crop.circle")!)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                Text("\(userData.name)")
                    .padding(.bottom, 50)
                    .font(.system(size: 20))

                VideoPlayer(player: AVPlayer(url: URL.documentsDirectory.appending(component: "movie.mp4")))
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
        }
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
