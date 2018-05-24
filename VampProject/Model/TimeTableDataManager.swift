//
//  TimeTableDataManager.swift
//  VampProject
//
//  Created by Gusto Nemec on 26/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation

class TimeTableDataManager {
    
    static let shared = TimeTableDataManager()
    var rooms = [Room]()
    
    private init() {}
    
    
    func makeGetCall(completition: @escaping (Room) -> ()) {
        // Set up the URL request
        let webPage: String = "http://dumo.cz/test/vamp2018prednasky.json"
        
        guard let url = URL(string: webPage) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let timeTable = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: [String : Any]] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                for miestnost in timeTable["miestnosti"]! {
                    let item = Room(name: miestnost.key, value: miestnost.value as! [String : Any])
                    if item.name != "" {
                        DispatchQueue.main.async {
                            if !self.rooms.contains(item) {
                                self.rooms.append(item)
                                self.rooms.sort(by: {$0.name < $1.name})
                                //self.timeTableView.reloadData()
                            }
                        }
                        completition(item)
                    }
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
}
