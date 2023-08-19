//
//  ProfilePictureView.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/1/23.
//

import SwiftUI
import Amplify

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
    
    let nervePink = UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userData: UserData
    
    @State private var shouldShowImagePicker = false
    @State var image: UIImage?
    
    var body: some View {
        VStack {
                  
            Spacer()
            
            HStack {
                Spacer()
                Text("Upload a profile picture")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
                    .glowBorder(color: Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)), lineWidth: 3)
                    .kerning(2.0)
                    .shadow(color: Color(nervePink).opacity(0.65), radius: 10)
                Spacer()
            }
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
                            .foregroundColor(.white).opacity(0.8)
                            .font(.system(size: 80))
                            .padding()
                            .foregroundColor(Color(.label))
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 80)
                    .stroke(Color.white.opacity(0.8), lineWidth: 3)
                )
                .padding(.top, 50)
                .padding(.bottom, 50)
            }
                        
            Button { Task{ await finishButtonPressed()}} label: {
                Text ("Finish")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
                    .glowBorder(color: Color(nervePink), lineWidth: 2)
                    .kerning(2.0)
                    .shadow(color: Color(nervePink).opacity(0.5), radius: 5)
                    .frame(width: 120)
                    .frame(height: 50)
                    .background(
                        Rectangle()
                            .fill(Color.white.opacity(0.0))
                    )
            }
            .border(Color(nervePink), width: 1)
            .padding(1.0)
            .border(Color.white, width: 1)
            .padding(1.0)
            .border(Color(nervePink), width: 1)
            .glowBorder(color: Color(nervePink), lineWidth: 1)
            .shadow(color: Color(nervePink).opacity(0.5), radius: 5)
            
            Spacer()
        }
        
        .background(Color(UIColor(red: 0.125, green: 0.118, blue: 0.118, alpha: 1)))
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
    
    func finishButtonPressed () async {
        
        if (image != nil) {
            saveImage(image: image!)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(userData.name, forKey: "name")
        defaults.set(userData.email, forKey: "email")
        defaults.set(userData.phoneNumber, forKey: "phoneNumber")
        defaults.set(userData.venmo, forKey: "venmo")
        defaults.set(true, forKey: "onboardingCompleted")
        defaults.set(true, forKey: "hasFinishedOnboarding")
        
        do{
            let item = User(name: userData.name,
                            venmo: userData.venmo, email: userData.email)
            let savedItem = try await Amplify.DataStore.save(item)
            print("Saved item: \(savedItem.name)")
            navModel.leaderboardPath.removeLast(navModel.leaderboardPath.count)
            navModel.isOnboarding = false
            navModel.hasFinishedOnboarding = true
        } catch {
            print("Could not save item to DataStore: \(error)")
        }
        
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
