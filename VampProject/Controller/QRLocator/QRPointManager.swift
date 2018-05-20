//
//  QRPointManager.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 20/05/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation

class QRPointManager {
    
    static func getQRPoint(pointString: String) -> QRPoint? {
        guard let pointId = parseIdFromQRPointString(pointString: pointString) else {
            return nil;
        }
        
        return QRPoint(id: pointId)
    }
    
    static private func parseIdFromQRPointString(pointString: String) -> NSUUID? {
        let matches = matchesForRegexInText(regex: "\\((.*?)\\)", text: pointString)
        
        if (matches.count != 1) {
            return nil
        } else {
            let uuidString = matches[0]
            
            let uuid = uuidString[1..<uuidString.count - 1]
            return NSUUID(uuidString: uuid)
        }
    }
    
    static func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            
            let results = regex.matches(in: text,
                                        options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("Invalid regex: \(error.localizedDescription)")
            return []
        }
        
    }
}
