//
//  Den.swift
//  VampProject
//
//  Created by Gusto Nemec on 13/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit

class Den: NSObject {
    
    var name : String
    var predmety = [Predmet]()
    
    init(name: String, value: Any) {
        self.name = name
        
        if let value = value as? [String : [String : Any]] {
            if let value = value["cas"] {
                for item in value{
                    let time = Predmet(name: item.key, value: item.value)
                    predmety.append(time)
                }
            }
            
        }
        
        
    }

}
