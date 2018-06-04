//
//  ARRoom.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 04/06/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

struct ARRoom: Decodable {
    
    let label: String
    let dimensions: ARDimensions
    let position: ARPosition
    
    private enum CodingKeys : String, CodingKey {
        case label
        case dimensions = "dimen"
        case position = "pos"
    }
}
