//
//  Cas.swift
//  VampProject
//
//  Created by Gusto Nemec on 13/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit

class Predmet: NSObject {

    var cas : String
    var kod : String?
    var nazov : String?
    
    init(name : String, value : Any) {
        self.cas = name
        if let value = value as? [String : String] {
            if let kod = value["kod"], let nazov = value["predmet"] {
                //self.predmet = Predmet(kod: kod, nazov: nazov)
                self.kod = kod
                self.nazov = nazov
                
            }
        }
        //print(self.kod!)
    }
}
