//
//  DummyUserData.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/8/23.
//

import Foundation
import SwiftUI

struct DummyUserData {
    
    static let testUsers = [
        LocalUser (id: UUID(), name: "Alex Holdings", ranking: 1, views: 713, profilePic: UIImage(named: "Alex Holdings"), change: "up"),
        LocalUser (id: UUID(), name: "William Irving", ranking: 2, views: 598, profilePic: UIImage(named: "William Irving"), change: "down"),
        LocalUser (id: UUID(), name: "Caty Gerritz", ranking: 3, views: 410, profilePic: UIImage(named: "Caty Gerritz"), change: "down"),
        LocalUser (id: UUID(), name: "Kevin Marshall", ranking: 4, views: 213, profilePic: UIImage(named: "Kevin Marshall"), change: "same"),
        LocalUser (id: UUID(), name: "Mary Smith", ranking: 5, views: 122, profilePic: UIImage(named: "Mary Smith"), change: "up"),
    ]
    
}

