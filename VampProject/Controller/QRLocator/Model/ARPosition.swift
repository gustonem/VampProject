//
//  ARPosition.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 04/06/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation
import ARKit

struct ARPosition: Decodable {
    
    let right : CGFloat?
    let up : CGFloat?
    let front : CGFloat?
    
    private enum CodingKeys : String, CodingKey {
        case right = "r"
        case up = "u"
        case front = "f"
    }
    
}
