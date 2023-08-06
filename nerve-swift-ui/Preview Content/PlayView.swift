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
    
    var body: some View {
        VStack {
            Text("Timeleft")
            ZStack{
                VideoPlayer(player: avPlayer)
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                VStack(alignment: .leading){
                    Text("Dare #2: act like a dog")
                        .font(.title)
                        .foregroundColor(.white)
                    .padding()
                }
                .frame(width: 200, height: 200)
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
        .onAppear {
            avPlayer.play()
        
        }
        .onChange(of: selectedItem) { _ in
            Task {
                do {
                    loadState = .loading

                    if let movie = try await selectedItem?.loadTransferable(type: Movie.self) {
                        
                        let destinationURL = URL.documentsDirectory.appending(component: userData.id.uuidString, directoryHint: .isDirectory)
                            .appending(component: movie.id.uuidString + ".mp4")
                        
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
