//
//  ProfilePictureView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/1/23.
//

import SwiftUI

struct ProfilePictureView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userData: UserData
    
    @State private var shouldShowImagePicker = false
    @State var image: UIImage?
    
    var body: some View {
        VStack {
                        
            Text("Choose a profile picture")
                .font(.system(size: 20))
                .foregroundColor(Color.pink.opacity(0.65))
                .bold()
                .monospaced()
                .kerning(1.0)
                .shadow(color: Color.pink.opacity(0.65), radius: 10)
                        
            Button {
                shouldShowImagePicker.toggle()
            } label: {
                VStack {
                    if let image = userData.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 143, height: 143)
                            .cornerRadius(80)
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 80))
                            .padding()
                            .foregroundColor(Color(.label))
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 80)
                    .stroke(Color.black, lineWidth: 3)
                )
                .padding(.top, 50)
                .padding(.bottom, 50)
            }
                        
            Button (action: finishButtonPressed) {
                Text ("Finish")
                    .foregroundColor(.pink.opacity(0.65))
                    .bold()
                    .shadow(color: Color.pink.opacity(0.65), radius: 10)
                    .cornerRadius(10)
                    .frame(width: 200)
                    .frame(height: 50)
                    .border(Color.pink)
                    .colorScheme(.light)
                    .shadow(color: Color.pink.opacity(0.95), radius: 20)
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
        
        .navigationDestination(for: Screen.self) { screen in
            LeaderboardView()
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $userData.profileImage)
                .ignoresSafeArea()
        }
    }
    
    func finishButtonPressed () {
//        navModel.leaderboardPath.append(Screen.leaderboard)
        navModel.leaderboardPath.removeLast(navModel.leaderboardPath.count)
                navModel.isOnboarding = false
                navModel.hasFinishedOnboarding = true
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    private let controller = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
