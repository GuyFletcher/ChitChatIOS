//
//  Message.swift
//  ChitChat
//
//  Created by Hart, Fletcher on 4/17/18.
//  Copyright © 2018 Hart, Fletcher. All rights reserved.
//

import Foundation

class Message: NSObject, Codable  {
    @objc var client: String?
    @objc var message: String?
    var lat: String?
    var long: String?
    var like: Int?
    var dislike: Int?
}
