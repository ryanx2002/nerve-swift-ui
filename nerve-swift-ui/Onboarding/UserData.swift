//
//  UserData.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/2/23.
//

import Foundation
import UIKit

class UserData: ObservableObject {
    @Published var name: String = ""
    @Published var profileImage: UIImage?
    @Published var phoneNumber: String = ""
    @Published var venmo: String = ""
    @Published var confirmationCode: String = ""
}

//struct User: Identifiable, Codable {
//    let id: String
//    var firstAndLastName: String?
//    var venmoHandle: String?
//}
