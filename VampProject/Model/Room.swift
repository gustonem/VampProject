//
//  Ucebna.swift
//  VampProject
//
//  Created by Gusto Nemec on 13/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit

class Room: Equatable {
    
    
    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    var name : String
    var days = [Day]()
    
    init(name: String, value: [String : Any]) {
        
        self.name = name
        
        if let value = value["dni"] as? [String : Any] {
            for day in value {
                let item = Day(name: day.key, value: day.value)
                self.days.append(item)
            }
        }
    }

}
