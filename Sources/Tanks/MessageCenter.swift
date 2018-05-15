//
//  MessageCenter.swift
//  TankLand
//
//  Created by Nicholas Hatzis-Schoch on 5/11/18.
//  Copyright © 2018 Slick Games. All rights reserved.
//

import Foundation

struct MessageCenter: CustomStringConvertible{
    var messageContainer: [Int: String]
    init(){
        self.messageContainer = [Int: String]()
    }
    mutating func sendMessage(id: Int, message: String){
        messageContainer[id] = message
    }
    func receiveMessage(id: Int)->String{
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
