//
//  SocketIOManager.swift
//  Task Afiniti
//
//  Created by Muhammad Danish Qureshi on 5/12/21.
//

import Foundation
import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket : SocketIOClient?
    var manager : SocketManager!

    let socketUrl = URL(string: "")

    // MARK: - Socket Configrations
    func setupAndEstablisConnection(completion:@escaping (Bool) -> ()){
        let socketConnectionStatus = socket?.status
        if socketConnectionStatus == SocketIOStatus.connected {
            completion(true)
        }
        else {
            self.setupSocket()
            self.establishConnection(completion: completion)
        }

    }

    fileprivate func setupSocket(){
        manager = SocketManager(socketURL: socketUrl!)
        socket = manager.defaultSocket
    }
    // --
    func closeConnection() {
        socket?.disconnect()
    }

    func removeEvents( _ events: [String]) {
        for event in events {
            socket?.off(event)
        }
    }

    func checkSocketStatus() {
        let socketConnectionStatus = socket?.status

        switch socketConnectionStatus {
        case .connected:
            print("socket connected")
        case .connecting:
            print("socket connecting")
        case .disconnected:
            print("socket disconnected")
        case .notConnected:
            print("socket not connected")
        case .none: break

        }
    }

    // --
    fileprivate func establishConnection(completion: @escaping (Bool) -> ()) {
        socket?.connect()
        self.checkSocketStatus()
        self.removeEvents([SocketListener.isConnected])
        socket?.on(SocketListener.isConnected) { (data, emitter) in
//            guard let weakSelf = self else {return}
            print("Scoket ON is_connected respone :\(data)")
//            weakSelf.startListeningSocketForMessages(){
//                dataDict in
//                print(dataDict)
//            }
            completion(true)
        }
    }
    // MARK: - Listening for Messages
    func startListeningSocketForMessages(completion: @escaping (MessageEmit?, Bool) -> ()) {
        self.removeEvents([SocketListener.message])
        socket?.on(SocketListener.message) { (data, emitter) in
            print("Listening for message :\(data)")
            let modified =  (data[0] as AnyObject)
            do {
                if let dictionary = modified as? [String: Any]{
                    let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let messageEmit = try decoder.decode(MessageEmit.self, from: jsonData)
                    completion(messageEmit, false)
                }
            } catch let error {
                print(error)

            }
        }
        socket?.on(SocketListener.listener) { (data, emitter) in
            print("Listening for listener :\(data)")
        }
        socket?.on(SocketListener.addedToRoom) { (data, emitter) in
            print("Listening for \(SocketListener.addedToRoom) :\(data)")
            completion(nil, true)
        }
        self.removeEvents([SocketListener.isWidgetOpen])
        socket?.on(SocketListener.isWidgetOpen) { (data, emitter) in
            print("Listening for \(SocketListener.isWidgetOpen) :\(data)")
            let modified =  (data[0] as AnyObject)
            if let dictionary = modified as? [String: Any] {
                if let widget = dictionary["widget"] as? Int {
                    if widget == 0 {
                        completion(nil, false)
                    } else {
                        completion(nil, true)
                    }
                }
            }
        }
    }

    // MARK: - Event Emitter
    func emit(_ event: String, with items: [Any]){
        self.socket?.emit(event, with: items)
    }
}
