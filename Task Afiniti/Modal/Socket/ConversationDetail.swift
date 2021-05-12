//
//  ConversationDetail.swift
//  rideely
//
//  Created by dev on 27/12/2019.
//  Copyright © 2019 Muhammad Danish Qureshi. All rights reserved.
//

import UIKit

class ConversationDetail: Codable {
    var tripConversationId: String?
    var messageList: [MessageEmit]?
    
       enum CodingKeys: String, CodingKey {
           case tripConversationId = "trip_conversation_id"
           case messageList = "data"
       }
}
