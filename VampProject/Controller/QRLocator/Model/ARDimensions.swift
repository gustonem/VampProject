//
//  ARDimensions.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 04/06/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation
import ARKit

struct ARDimensions: Decodable {

    let width : CGFloat
    let height : CGFloat
    let length : CGFloat
    
    private enum CodingKeys : String, CodingKey {
        case width = "w"
        case height = "h"
        case length = "l"
    }
}
