//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Seyhun Koçak on 27.02.2024.
//

import Foundation


class UserSingleton {
    static let sharedUserInfo = UserSingleton()
    var email = ""
    var username = ""
    
    
    private init() {
        
    }
}
