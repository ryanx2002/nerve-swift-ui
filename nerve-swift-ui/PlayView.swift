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
        case unknown, loading, loaded(Movie), failed
    }

    @State private var selectedItem: PhotosPickerItem?
    @State private var loadState = LoadState.unknown
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userData: UserData

    let avPlayer = AVPlayer(url: Movie.defaultPlayViewVideoURL)
    
    // timer setup
    @State var timeRemaining = 60000
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        VStack {
            
            ZStack(alignment: .center){
                VideoPlayer(player: avPlayer)/*
                    .scaledToFit()
                    .scaleEffect(2.5)
                    .aspectRatio(contentMode: .fill)*/
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "hourglass")
                                .foregroundColor(.white)
                            Text("Time Remaining")
                                .foregroundColor(.white)
                        }
                        .padding(.top, 5)
                        .padding(.horizontal, 5)
//                        .alignment(.center)
                        
                        Text("\(formatter.string(from: TimeInterval(timeRemaining)) ?? "00:00:00")")
                            .onReceive(timer) { _ in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                    }
                    .background(Color.black.opacity(0.3))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
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
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            PhotosPicker("Upload", selection: $selectedItem, matching: .videos)

            switch loadState {
            case .unknown:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let movie):
                VideoPlayer(player: AVPlayer(url: movie.url))
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            case .failed:
                Text("Import failed")
            }
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
        }
    }
    
    func profilePressed() {
        navModel.leaderboardPath.append(Screen.profile)
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}











//final class PlayView: NSObject, View {
//    @State private var videoURL: URL?
//
//    var body: some View {
//        VStack {
//            Text("Upload Video")
//                .font(.title)
//                .padding()
//
//            Button(action: {
//                // Code to open video picker
//                // This code depends on the platform you're developing for (iOS, macOS, etc.)
//                // Here's an example for iOS using UIImagePickerController
//                let picker = UIImagePickerController()
//                picker.sourceType = .photoLibrary
//                picker.mediaTypes = ["public.movie"]
//                picker.delegate = self
//                if let windowScene = UIApplication.shared.windows.first?.windowScene {
//                                    windowScene.windows.first?.rootViewController?.present(picker, animated: true, completion: nil)
//                                }
//                            })
//            {
//                Text("Select Video")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//
//            if let videoURL = videoURL {
//                VideoPlayer(player: AVPlayer(url: videoURL))
//                    .frame(height: 300)
//                    .padding()
//            }
//        }
//    }
//}
//
//extension PlayView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let videoURL = info[.mediaURL] as? URL {
//            self.videoURL = videoURL
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
//
//struct PlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayView()
//    }
//}
