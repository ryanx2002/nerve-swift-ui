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
    var password: String
    var confirmationCode: String
    var venmo: String
    var change: String
    var ranking: Int
    var email: String
    
    init() {
        let userDefaults = UserDefaults.standard
        self.name = ""
        self.email =  ""
        self.phoneNumber =  ""
        self.confirmationCode =  ""
        self.password =  ""
        self.venmo =  ""
        self.change =  ""
        self.ranking = 0
    }
}
