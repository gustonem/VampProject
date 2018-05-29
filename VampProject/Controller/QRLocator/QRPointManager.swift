//
//  QRPointManager.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 20/05/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation

class QRPointManager {
    
    static let QR_POINT_HOSTING_URL: String = "https://3fb9a5ba-07d1-4396-9bc2-a207791118f5.htmlpasta.com" // TODO fix hosting
    
    static var knownQrPoints: [QRPoint]?
    
    static func getQRPoint(pointString: String, completion: @escaping (_: QRPoint?)->()) {
        guard let pointId = parseIdFromQRPointString(pointString: pointString) else {
            completion(nil)
            return
        }
    
        getKnownQrPoints { qrPoints in
            guard qrPoints != nil else {
                completion(nil)
                return
            }
            
            for qrPoint in qrPoints! {
                if qrPoint.getId().isEqual(pointId) {
                    completion(qrPoint)
                }
            }
            
            completion(nil)
        }
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
    
    static private func matchesForRegexInText(regex: String!, text: String!) -> [String] {
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
    
    private static func getKnownQrPoints(completion: @escaping (_: [QRPoint]?)->()) {
        if knownQrPoints != nil {
            completion(knownQrPoints!)
            return
        }
        
        downloadQrPoints(completion: completion)
    }
    
    static private func downloadQrPoints(completion: @escaping (_: [QRPoint]?)->()) {
        // Asynchronous Http call to your api url, using URLSession:
        URLSession.shared.dataTask(with: URL(string: QR_POINT_HOSTING_URL)!) { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                print(String(decoding: data!, as: UTF8.self))
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] {
                        //For getting customer_id try like this
                        if let qrPoints = json["qrPoints"] as? [[String: Any]] {
                            knownQrPoints = []
                            for qrPointJson in qrPoints {
                                let qrPointUuidString = qrPointJson["id"] as? String
                                if qrPointUuidString != nil {
                                    continue
                                }
                                let uuid = NSUUID(uuidString: qrPointUuidString!)
                                let qrPointLabel = qrPointJson["label"] as? String
                                let qrPointMuniMapId = qrPointJson["munimap"] as? String
                                
                                if uuid != nil && qrPointLabel != nil && qrPointMuniMapId != nil {
                                    knownQrPoints?.append(QRPoint(id: uuid!, label: qrPointLabel!, muniMapId: qrPointMuniMapId!))
                                }
                            }
                            completion(knownQrPoints)
                            return
                        }
                    }
                    completion(nil)
                    return
                } catch let error {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
            } else {
                completion(nil)
                return
            }
        }.resume()
    }
}
