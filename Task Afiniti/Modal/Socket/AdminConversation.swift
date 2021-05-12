//
//  AdminChat.swift
//  rideely
//
//  Created by dev on 06/02/2020.
//  Copyright © 2020 Muhammad Danish Qureshi. All rights reserved.
//

import UIKit

class AdminConversation: Codable {
    var adminAvailable: Bool?
    var userId: String?
    var adminId: String?    
    var name: String?

    enum CodingKeys: String, CodingKey {
        case adminAvailable = "admin_available"
        case userId = "user_id"
        case adminId = "admin_id"
        
    }
}
