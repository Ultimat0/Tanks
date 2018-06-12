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
    return "\(hour!):\(minute!):\(second!)"
}

struct Logger{
    var majorLoggers = [GameObject]()
    init(){
    }
    mutating func log(_ message: String){
        print(message)
    }
    mutating func addLog(_ gameObject: GameObject, _ message: String){
        log("\(tankWorld.turn) \(getTime()) \(gameObject.id) \(gameObject.position) \(message)")
    }
    mutating func addMajorLog(gameObject: GameObject, message: String){
        majorLoggers.append(gameObject)
        addLog(gameObject, "\(gameObject.id): \(message)")
    }

}
