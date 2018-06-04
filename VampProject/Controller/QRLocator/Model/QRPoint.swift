//
//  QRPoint.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 20/05/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation
import UIKit

struct QRPoint : Decodable {
    
    let uuidString : String
    let label : String
    let muniMapId : String
    
    let rooms : [ARRoom]
    
    func getUuid() -> NSUUID? {
        return NSUUID(uuidString: uuidString)
    }
    
    private enum CodingKeys : String, CodingKey {
        case uuidString = "id"
        case label
        case muniMapId = "munimap"
        case rooms = "arObjects"
    }
}
