//
//  User.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/6/23.
//

import Foundation
import UIKit
import SwiftUI

struct User: Identifiable {
    
    let id: UUID
    let name: String
    let ranking: Int
    let views: Int
    let profilePic: UIImage?
    
    static let testUsers = [
        User (id: UUID(), name: "Alex Holdings", ranking: 1, views: 6523, profilePic: UIImage(named: "Alex Holdings")),
        User (id: UUID(), name: "William Irving", ranking: 2, views: 5821, profilePic: UIImage(named: "William Irving")),
        User (id: UUID(), name: "Caty Gerritz", ranking: 3, views: 3209, profilePic: UIImage(named: "Caty Gerritz")),
        User (id: UUID(), name: "Kevin Marshall", ranking: 4, views: 1958, profilePic: UIImage(named: "Kevin Marshall")),
        User (id: UUID(), name: "Mary Smith", ranking: 5, views: 1098, profilePic: UIImage(named: "Mary Smith")),
    ]
    
}
