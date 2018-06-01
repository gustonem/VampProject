//
//  QRPoint.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 20/05/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation
import UIKit

class QRPoint {
    
    let id : NSUUID
    let label : String
    let muniMapId : String
    
    init(id : NSUUID, label : String, muniMapId : String) {
        self.id = id
        self.label = label
        self.muniMapId = muniMapId
    }
    
    func getId() -> NSUUID! {
        return id
    }
    
    func getLabel() -> String! {
        return label
    }
    
    func getMuniMapId() -> String! {
        return muniMapId
    }
}
