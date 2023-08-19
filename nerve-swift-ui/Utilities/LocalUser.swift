//
//  User.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/6/23.
//

import Foundation
import UIKit
import SwiftUI


struct LocalUser: Identifiable {
    
    let id: UUID
    let name: String
    let ranking: Int
    let views: Int
    let profilePic: UIImage?
    let change: String
}
