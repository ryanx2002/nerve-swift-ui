//
//  PhoneNumber.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 7/31/23.
//

import SwiftUI
import Amplify

struct OnboardingFormView: View {
    
    let nervePink = UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var userData: UserData
    
    @State private var phoneNumber = ""
    var screen: Screen
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(screen.prompt!)
                .font(.system(size: 26))
                .foregroundColor(.white)
                .glowBorder(color: Color(UIColor(red: 1, green: 0, blue: 0.898, alpha: 1)), lineWidth: 3)
                .kerning(2.0)
                .shadow(color: Color(nervePink).opacity(0.65), radius: 10)

            TextField(screen.valueName!, text: binding())
                .padding(.top, 50)
                .padding(.bottom, 50)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .textContentType(screen.textType)
                .autocapitalization(.none)
                .keyboardType(screen.keyboardType)
                .foregroundColor(.white)
                .glowBorder(color: Color(nervePink), lineWidth: 2)
                .font(.system(size: 26))
                .shadow(color: Color(nervePink).opacity(0.5), radius: 5)
            
            Button { Task { await nextButtonPressed() }} label: {
                Text ("Next")
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
    }
    
    func nextButtonPressed () async {
        switch screen {
        case .password:
            let userAttributes = [AuthUserAttribute(.email, value: userData.email)]
            let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
            do {
                    let signUpResult = try await Amplify.Auth.signUp(
                        username: userData.email,
                        password: userData.password,
                        options: options
                    )
                    if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                        print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
                    } else {
                        print("SignUp Complete")
                    }
                    navigationModel.leaderboardPath.append(screen.next!)
                } catch let error as AuthError {
                    print("An error occurred while registering a user \(error)")
                    do {
                            let signInResult = try await Amplify.Auth.signIn(
                                username: userData.email,
                                password: userData.password
                                )
                            print(signInResult)
                            if signInResult.isSignedIn {
                                print("Sign in succeeded")
                            }
                        
                        //CALL BACKEND FOR USER ATTRIBUTES
                        
                        navigationModel.leaderboardPath.removeLast(navigationModel.leaderboardPath.count)
                        navigationModel.isOnboarding = false
                        navigationModel.hasFinishedOnboarding = true
                        
                        
                        } catch let error as AuthError {
                            print("Sign in failed \(error)")
                        } catch {
                            print("Unexpected error: \(error)")
                        }
                } catch {
                    print("Unexpected error: \(error)")
                }
        case .confirmationCode:
            do {
                   let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                       for: userData.email,
                       confirmationCode: userData.confirmationCode
                   )
                   print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
                    navigationModel.leaderboardPath.append(screen.next!)
               } catch let error as AuthError {
                   print("An error occurred while confirming sign up \(error)")
               } catch {
                   print("Unexpected error: \(error)")
               }
        default:
            navigationModel.leaderboardPath.append(screen.next!)
        }
    }
    
    func binding() -> Binding<String> {
        print("screen", screen)
        switch screen {
        case .name:
            return $userData.name
        case .phoneNumber:
            return $userData.phoneNumber
        case .email:
            return $userData.email
        case .password:
            return $userData.password
        case .venmo:
            return $userData.venmo
        case .confirmationCode:
            return $userData.confirmationCode
        default: return Binding(get: { "empty" }, set: { _ in })
        }
    }
}

struct OnboardingFormView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFormView(screen: .name)
    }
}
