//
//  ProfilePictureView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/1/23.
//

import SwiftUI

func saveImage(image: UIImage) {
    guard let data = image.jpegData(compressionQuality: 1) else {
        return
    }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
        return
    }
    do {
        try data.write(to: directory.appendingPathComponent("profile.jpg")!)
        return
    } catch {
        print(error.localizedDescription)
        return
    }
}


struct ProfilePictureView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userData: UserData
    
    @State private var shouldShowImagePicker = false
    @State var image: UIImage?
    
    var body: some View {
        VStack {
                  
            Spacer()
            
            Text("Choose a profile picture")
                .font(.system(size: 20))
                .foregroundColor(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)))
                .bold()
                .monospaced()
                .kerning(1.0)
                .shadow(color: Color.pink.opacity(0.65), radius: 10)
                        
            Button {
                shouldShowImagePicker.toggle()
            } label: {
                VStack {
                    if let image {
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
                    .foregroundColor(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)))
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .monospaced()
                    .kerning(1.0)
                    .frame(width: 200)
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
            }
            .border(Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)), width: 2)
            .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 4)
            
            Spacer()
        }
        
        .background(Color(UIColor(red: 0.988, green: 0.965, blue: 0.953, alpha: 1)))
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
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
    }
    
    func finishButtonPressed () {
        
        if (image != nil) {
            saveImage(image: image!)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(userData.name, forKey: "name")
        defaults.set(userData.phoneNumber, forKey: "phoneNumber")
        defaults.set(userData.venmo, forKey: "venmo")
        defaults.set(true, forKey: "onboardingCompleted")
        
//        navModel.leaderboardPath.append(Screen.leaderboard)
        navModel.leaderboardPath.removeLast(navModel.leaderboardPath.count)
        navModel.isOnboarding = false
        navModel.hasFinishedOnboarding = true
        defaults.set(true, forKey: "hasFinishedOnboarding")
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
