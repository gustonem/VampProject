//
//  QRPointManager.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 20/05/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation
import ARKit

class QRPointManager {
    
    static let QR_POINT_HOSTING_URL: String = "http://server-smart-university.a3c1.starter-us-west-1.openshiftapps.com/get/qrpoints"
    
    static var knownQrPoints: [QRPoint]?
    static var downloading: Bool! = false
    
    static func getQRPoint(pointString: String, completion: @escaping (_: QRPoint?)->()) {
        guard let parsedPointId = parseIdFromQRPointString(pointString: pointString) else {
            completion(nil)
            return
        }
    
        getKnownQrPoints { qrPoints in
            guard qrPoints != nil else {
                completion(nil)
                return
            }
            
            for qrPoint in qrPoints! {
                guard let pointId = qrPoint.getUuid() else {
                    continue
                }
                
                if pointId.isEqual(parsedPointId) {
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
        
        if downloading {
            completion(nil)
        } else {
            downloadQrPoints(completion: completion)
        }
    }
    
    static private func downloadQrPoints(completion: @escaping (_: [QRPoint]?)->()) {
        downloading = true
        // Asynchronous Http call to your api url, using URLSession:
        URLSession.shared.dataTask(with: URL(string: QR_POINT_HOSTING_URL)!) { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                if let parsedQrPoints = parseQrPoints(data: data!) {
                    knownQrPoints = parsedQrPoints
                    downloading = false
                    completion(parsedQrPoints)
                    return
                }
            }
            
            completion(nil)
            downloading = false
        }.resume()
    }
    
    static private func parseQrPoints(data: Data!) -> [QRPoint]? {
        do {
            let result = try JSONDecoder().decode(GetPointsResponse.self, from: data)
            return result.qrPoints
        } catch {
            print(error)
        }
        return nil
        
//
//        do {
//            if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] {
//                //For getting customer_id try like this
//                if let qrPoints = json["qrPoints"] as? [[String: Any]] {
//                    var parsedPoints : [QRPoint] = []
//                    for qrPointJson in qrPoints {
//                        let qrPointUuidString = qrPointJson["id"] as? String
//                        guard qrPointUuidString != nil else {
//                            continue
//                        }
//                        let uuid = NSUUID(uuidString: qrPointUuidString!)
//                        let qrPointLabel = qrPointJson["label"] as? String
//                        let qrPointMuniMapId = qrPointJson["munimap"] as? String
//
//                        let rooms : [ARRoom] = []
//
//
//                        if uuid != nil && qrPointLabel != nil && qrPointMuniMapId != nil {
//                            parsedPoints.append(QRPoint(id: uuid!, label: qrPointLabel!, muniMapId: qrPointMuniMapId!, rooms: rooms))
//                        }
//                    }
//                    return parsedPoints
//                }
//            }
//        } catch let error {
//            print("QRPoints JSON parsing error: " + error.localizedDescription)
//        }
//        return nil
    }
}
