//
//  Den.swift
//  VampProject
//
//  Created by Gusto Nemec on 13/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit

class Day: NSObject {
    
    var nameIndex : Int
    var subjects = [Subject]()
    
    init(name: String, value: Any) {
        
        switch name {
        case "Po":
            self.nameIndex = 0
        case "Út":
            self.nameIndex = 1
        case "St":
            self.nameIndex = 2
        case "Čt":
            self.nameIndex = 3
        case "Pá":
            self.nameIndex = 4
        default:
            self.nameIndex = 5
        }
        
        if let value = value as? [String : [String : Any]] {
            if let value = value["cas"] {
                for item in value{
                    let time = Subject(name: item.key, value: item.value)
                    subjects.append(time)
                }
            }
            
        }
        
        
    }

}
