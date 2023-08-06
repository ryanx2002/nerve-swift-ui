//
//  User.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/6/23.
//

import Foundation
import UIKit

struct User: Identifiable {
    
    let id: UUID
    let name: String
    let ranking: Int
    let views: Int
    let profilePic: UIImage?
    
    static let testUsers = [
        User (id: UUID(), name: "Alex Holdings", ranking: 1, views: 69000, profilePic: nil),
        User (id: UUID(), name: "Kate Willimas", ranking: 2, views: 58000, profilePic: nil)

    ]
    
}
