//
//  MessageCenter.swift
//  TankLand
//
//  Created by Nicholas Hatzis-Schoch on 5/11/18.
//  Copyright © 2018 Slick Games. All rights reserved.
//

import Foundation

struct MessageCenter: CustomStringConvertible{
    var messageContainer: [String: String]
    init(){
        self.messageContainer = [String: String]()
    }
    mutating func sendMessage(id: String, message: String){
        messageContainer[id] = message
    }
    func receiveMessage(id: String)->String{
        return messageContainer[id]!
    }
    var description: String{
        var desc = ""
        for e in messageContainer{
            desc.append("ID: \(e.0) Message: \(e.1)\n")
        }
        return desc
    }
}


