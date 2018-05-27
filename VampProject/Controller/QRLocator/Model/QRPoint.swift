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
    let DEFAULT_MAP_URL_STRING: String = "https://08668375-551f-4033-a3b8-f1f6715dfb79.htmlpasta.com"
    let DEFAULT_UI_IMAGE_NAME: String = "Point FI MUNI Main Hall"
    
    let id : NSUUID
    
    init(id : NSUUID) {
        self.id = id
    }
    
    func getURL() -> String! {
        return DEFAULT_MAP_URL_STRING // TODO implement
    }
    
    func getUIImage() -> UIImage! {
        return UIImage(named: DEFAULT_UI_IMAGE_NAME)! // TODO implement
    }
}
