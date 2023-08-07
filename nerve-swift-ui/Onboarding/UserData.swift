//
//  UserData.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/2/23.
//

import Foundation
import UIKit

class UserData: Identifiable, ObservableObject {
    
    var name: String
    var phoneNumber: String
    var venmo: String
    
    init() {
        let userDefaults = UserDefaults.standard
        self.name = userDefaults.string(forKey: "name") ?? ""
        self.phoneNumber = userDefaults.string(forKey: "phoneNumber") ?? ""
        self.venmo = userDefaults.string(forKey: "venmo") ?? ""
    }
}

//struct User: Identifiable, Codable {
//    let id: String
//    var firstAndLastName: String?
//    var venmoHandle: String?
//}
