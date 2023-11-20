//
//  Constants.swift
//  Khawi
//
//  Created by Karim Amsha on 6.11.2023.
//

import Foundation
import Alamofire
import Firebase
import Firebase

struct Constants {
    static let baseURL = "https://khawii-598d2a7a9203.herokuapp.com/api"
    static let apiKey = "f8dd3a017f39b886c815f5cb248d26a2" // API KEY
    static let FCMLink = "https:fcm.googleapis.com/fcm/send"
    static let serverkey            = "AAAAZ8ldFPY:APA91bE3eeL5kCX28ZElBjeobvkMORu7Hb7SQjXrZuI_pZMGgPOUOjiQyb1Fskb2BfUln-6bP6cBOsnrGJoybdUlCofzqQjMR4Z-8oBy52xGFXOfLj7-T6vfR9DuZym24OZ4EZ2krBfn"
    static let headers: HTTPHeaders = ["Authorization":"key = \(serverkey)", "Accept": "application/json"]
    static let dbRef                = Database.database().reference()
    static let usersRef             = dbRef.child("user")
    static let userLocationRef      = dbRef.child("userLocation")
    static let trackingRef          = dbRef.child("tracking")
    static let messagesRef          = dbRef.child("messages")
    static let messagesList         = "messagesList"
    static let lastMessage          = "lastMessage"
    static let lastMessageDate      = "lastMessageDate"
    static let receiverId           = "receiverId"
    static let senderId             = "senderId"
    static let chatEnabled          = "chatEnabled"
    static let id                   = "id"
    static let orderId              = "orderId"
    static let distance             = 50.0
}
