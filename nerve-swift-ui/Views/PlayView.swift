//
//  PlayView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/4/23.
//

import PhotosUI
import SwiftUI
import AVFoundation
import AVKit

struct PlayView: View {
    
    enum LoadState {
        case loading, loaded(Movie), failed
    }
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var loadState = LoadState.loading
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userData: UserData
    @State private var showSecondScreen: Bool = false
    
    @State private var animate = false
    @State private var likeAnimation = false
    @State private var isLiked = false
    private var duration: Double = 0.1

    
    func performAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
            likeAnimation = false
        }
    }
    
    let nervePink = UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)

    let avPlayer = AVPlayer(url: Movie.defaultPlayViewVideoURL)
    
    var body: some View {
        ZStack {
            ScrollView {
                
                ZStack(alignment: .center){
                    VideoPlayer(player: avPlayer)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    
                    //timer, dare, and upload button
                    VStack {
                        
                        Spacer()
                        
                        //timer
                        VStack {
                            Text("Time Remaining")
                                .foregroundColor(.white)
                            HStack (spacing: 3){
                                Image(systemName: "hourglass")
                                    .foregroundColor(.white)
                                TimerManager()
                                    .baselineOffset(-5)
                            }
                        }
                        .padding(5)
                        .background(Color.black.opacity(0.3))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                        
                        Spacer()
                        Spacer()
                        
                        //dare
                        VStack(alignment: .leading){
                            Text("Streak a field")
                                .font(.title)
                                .foregroundColor(Color(UIColor(red: 250, green: 255, blue: 0, alpha: 1)))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .bold()
                                .padding(.bottom, 10)
                            Text("$200")
                                .font(.system(size: 45))
                                .foregroundColor(Color(UIColor(red: 250, green: 255, blue: 0, alpha: 1)))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .bold()
                            
                        }
                        .frame(width: 220, height: 150)
                        .background(Color.black.opacity(0.4))
                        .multilineTextAlignment(.center)
                        
                        Spacer()
                        Spacer()
                        
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                //the uploaded video should appear here
                VStack{
                    
                    switch loadState {
                    case .loading:
                        EmptyView()
                    case .loaded(let movie):
                        HStack{
                            Text("#6")
                                .foregroundColor(.white)
                                .bold()
                                .padding(.leading, 10)
                            Image(uiImage: getSavedImage(named: "profile.jpg") ?? UIImage(systemName: "person.crop.circle")!)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            
                            Text("\(userData.name)")
                                .foregroundColor(.white)
                                .bold()
                            switch userData.change {
                                case "up":
                                    Image("up")
                                case "down":
                                    Image("down")
                                default :
                                    Image("same")
                            }
                            Spacer()
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .padding(.trailing, 10)
                        }
                        ZStack (alignment: .center){
                            VideoPlayer(player: AVPlayer(url: movie.url))
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .onTapGesture (count: 2) {
                                    likeAnimation = true
                                    performAnimation()
                                    self.isLiked.toggle()
                                }
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .scaleEffect(likeAnimation ? 1 : 0)
                                .opacity(likeAnimation ? 1 : 0)
                                .animation(.spring())
                                .foregroundColor(isLiked ? .red : .black)
                        }
                        HStack {
                            Button (action: {
                                self.animate = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + self.duration, execute: {
                                    self.animate = false
                                    self.isLiked.toggle()
                                })
                            }) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(isLiked ? .red : .white)
                                    .frame(width: 18, height: 18)
                            }
                                .padding(.leading, 10)
                                .animation(.easeIn (duration: duration))
                            Image(systemName: "bubble.right")
                                .foregroundColor(.white)
                                .frame(width: 18, height: 18)
                            Spacer()
                            Text("0")
                                .foregroundColor(Color.white)
                            Image(systemName: "eye")
                                .foregroundColor(Color.white)
                                .scaleEffect(0.7)
                                .padding(.trailing, 10)
                        }
                    case .failed:
                        Text("Import failed")
                    }
                }
            }
            .background(Color.gray)
            
            //upload button
            VStack{
                PhotosPicker("Play", selection: $selectedItem, matching: .videos)
                    .font(.system(size: 26))
                    .foregroundColor(.white)
                    .glowBorder(color: Color(nervePink), lineWidth: 2)
                    .kerning(2.0)
                    .shadow(color: Color(nervePink).opacity(0.5), radius: 5)
                    .frame(width: 120)
                    .frame(height: 50)
                    .background(
                        Rectangle()
                            .fill(Color.black.opacity(0.8))
                    )
                    .fullScreenCover(isPresented: $showSecondScreen, content: {
                        SecondScreen()
                    })
            }
            .border(Color(nervePink), width: 1)
            .padding(1.0)
            .border(Color.white, width: 1)
            .padding(1.0)
            .border(Color(nervePink), width: 1)
            .glowBorder(color: Color(nervePink), lineWidth: 1)
            .shadow(color: Color(nervePink).opacity(0.5), radius: 5)
            .padding(.top, 625)
        }
        
        .navigationTitle("Play")
        .addProfileToolbar(pressedHandler: profilePressed)
        .onDisappear {
            avPlayer.pause()
        }
        
        .onAppear {
            avPlayer.play()
        }
        .onChange(of: selectedItem) { _ in
            Task {
                do {
                    loadState = .loading
                    
                    if let movie = try await selectedItem?.loadTransferable(type: Movie.self) {
                        
                        let destinationURL = URL.documentsDirectory.appending(component: "movie.mp4")
                        
                        do {
                            try FileManager.default.moveItem(at: movie.url, to: destinationURL)
                            loadState = .loaded(movie)
                        } catch {
                            print(error.localizedDescription, error)
                            loadState = .failed
                        }
                        
                        loadState = .loaded(movie)
                    } else {
                        loadState = .failed
                    }
                } catch {
                    loadState = .failed
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                showSecondScreen = true
            }
        }
    }
    
    func profilePressed() {
        navModel.leaderboardPath.append(Screen.profile)
    }
    
}

struct SecondScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(20)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                Spacer()
                
                Text("$200")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("pending")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Text("Your dare is being reviewed. \nIt'll show up on this page for now. \nYou'll earn $200 once it's verified.")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                Spacer()
                Spacer()
            }
            
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}
