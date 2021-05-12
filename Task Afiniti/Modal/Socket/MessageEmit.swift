//
//  MessageEmit.swift
//  rideely
//
//  Created by dev on 26/12/2019.
//  Copyright © 2019 Muhammad Danish Qureshi. All rights reserved.
//

import UIKit

class MessageEmit: Codable {
    var messageId: String?
    var senderId: String?
    var receiverId: String?
    var message: SocketMessage?
    var name: String?
    var dataTime: Int?
    var image: String?
    var tripConversationId: String?
    var senderType: String?
    var tripId: String?
    var type: String?
    var supportConversationId: String?
    var ticketId: String?
    var createdAt: Int?
    var receiverType: String?
    
    enum CodingKeys: String, CodingKey {
        case messageId = "id"
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case message = "message"
        case name = "name"
        case dataTime = "date_time"
        case image = "image"
        case tripConversationId = "trip_conversation_id"
        case senderType = "sender_type"
        case tripId = "trip_id"
        case type = "type"
        case supportConversationId = "support_conversation_id"
        case ticketId = "ticket_id"
        case createdAt = "createdAt"
        case receiverType = "receiver_type"
    }
}
