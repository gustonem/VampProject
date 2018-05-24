//
//  Cas.swift
//  VampProject
//
//  Created by Gusto Nemec on 13/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit

class Subject: NSObject {
    
    var time : Int
    var code : String?
    var name : String?
    
    init(name : String, value : Any) {
        self.time = Int(name.prefix(2)) ?? 0
        
        
        if let value = value as? [String : String] {
            if let code = value["kod"], let name = value["predmet"] {
                self.code = String(code.prefix(5))
                self.name = name
                
            }
        }
    }
}

