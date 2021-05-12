//
//  SocketMessage.swift
//  rideely
//
//  Created by dev on 26/12/2019.
//  Copyright © 2019 Muhammad Danish Qureshi. All rights reserved.
//

import UIKit

class SocketMessage: Codable {
    var messageText: String?
    
       enum CodingKeys: String, CodingKey {
           case messageText = "text"
       }
}
