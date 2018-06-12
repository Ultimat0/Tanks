//
//  Logger.swift
//  TankLand
//
//  Created by Nicholas Hatzis-Schoch on 5/11/18.
//  Copyright © 2018 Slick Games. All rights reserved.
//

import Foundation

func getTime()->String{
    let date = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute, .second], from: date)
    let hour = components.hour
    let minute = components.minute
    let second = components.second
    return "\(hour):\(minute):\(second)"
}

struct Logger{
    var majorLoggers = [GameObject]()
    init(){
    }
    mutating func log(_ message: String){
        print(message)
    }
    mutating func addLog(gameObject: GameObject, message: String){
        if majorLoggers.contains(where: {$0 === gameObject}) {
            log("\(tankWorld.turn) \(getTime()) \(gameObject.id) \(gameObject.position) \(message)")
        }
        log("\(tankWorld.turn) \(getTime()) \(gameObject.id) is not allowed to log!")
    }
    mutating func addMajorLogger(gameObject: GameObject, message: String){
        majorLoggers.append(gameObject)
        addLog(gameObject: gameObject, message: "\(gameObject.id): \(message)")
    }
}
