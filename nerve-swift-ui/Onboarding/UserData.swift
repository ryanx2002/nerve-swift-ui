//
//  UserData.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/2/23.
//

import Foundation
import UIKit

class UserData: Identifiable, ObservableObject {
    
    var id: UUID
    @Published var name: String
    @Published var profileImage: UIImage?
    @Published var phoneNumber: String
    @Published var venmo: String
    @Published var confirmationCode: String
    
    init(id: UUID = UUID(), name: String = "", profileImage: UIImage? = nil, phoneNumber: String = "", venmo: String = "", confirmationCode: String = "") {
        self.id = id
        self.name = name
        self.profileImage = profileImage
        self.phoneNumber = phoneNumber
        self.venmo = venmo
        self.confirmationCode = confirmationCode
    }
}

//struct User: Identifiable, Codable {
//    let id: String
//    var firstAndLastName: String?
//    var venmoHandle: String?
//}
