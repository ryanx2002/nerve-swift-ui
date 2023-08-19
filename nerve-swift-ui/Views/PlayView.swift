//
//  PlayView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/4/23.
//

import AVKit
import PhotosUI
import SwiftUI
import AVFoundation

struct PlayView: View {
    
    enum LoadState {
        case loading, loaded(Movie), failed
    }
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var loadState = LoadState.loading
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userData: UserData
    @State private var showSecondScreen: Bool = false
    
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
                        Text("asdf")
                            .foregroundColor(.blue)
                        VideoPlayer(player: AVPlayer(url: movie.url))
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .onTapGesture (count: 2) {
                                <#code#>
                            }
                        HStack {
                            Image(systemName: "heart")
                                .padding(.leading, 10)
                            Image(systemName: "bubble.right")
                            Spacer()
                        }
                    case .failed:
                        Text("Import failed")
                    }
                }
            }
            
            //upload button
            VStack{
                PhotosPicker("Play", selection: $selectedItem, matching: .videos)
                    .foregroundColor(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)))
                    .font(.system(size: 30))
                    .bold()
                    .frame(width: 120)
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
                    .fullScreenCover(isPresented: $showSecondScreen, content: {
                        SecondScreen()
                    })
            }
            .border(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)), width: 3)
            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 4)
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
