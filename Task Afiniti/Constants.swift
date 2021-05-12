//
//  Constants.swift
//  Task Afiniti
//
//  Created by Muhammad Danish Qureshi on 5/7/21.
//

import Foundation
enum AWSDirectory {
    static let bucketName = "Put bucket name here"
    static let accessKey = "Put access Key here"
    static let secretKey = "Puch secreate key here"}
enum AfinityImageUserDefaultsKey {
    static let counter = "AfinitiImageCounter"
}
enum SocketListener {
    static let isConnected = "is_connected"
    static let message = "message"
    static let listener = "listener"
    static let updatedLocation = "updated_location"
    static let addedToRoom = "added_toRoom"
    static let adminAvaialble = "is_admin_available"
    static let isWidgetOpen = "is_widget_open"
}
enum SocketEmitter{
    static let registerUser = "register_user"
    static let sendMessage = "send_message"
    static let rideStarted = "ride_started"
    static let rideMap = "ride_map"
    static let driverLeaveMap = "driver_leave_map"
    static let adminAvaialble = "check_admin_availibility"
    static let handshake = "handshake"
}
