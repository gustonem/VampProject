//
//  Ucebna.swift
//  VampProject
//
//  Created by Gusto Nemec on 13/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit

class Ucebna: NSObject {
    
    var name : String
    var days = [Den]()
    
    init(name: String, value: [String : Any]) {
        
        self.name = name
        
        if let v = value["dni"] as? [String : Any] {
            for day in v {
                let item = Den(name: day.key, value: day.value)
                self.days.append(item)
            }
        }
    }

}
