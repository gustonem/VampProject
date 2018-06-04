//
//  GetPointsResponse.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 04/06/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation

struct GetPointsResponse : Decodable {
    
    let qrPoints : [QRPoint]
}
