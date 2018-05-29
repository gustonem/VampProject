//
//  TodayViewController.swift
//  NearestRoomWidget
//
//  Created by Gusto Nemec on 24/05/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit
import NotificationCenter
import EstimoteProximitySDK

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var roomLabel: UILabel!
    var manager = TimeTableDataManager.shared
    var rooms = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    var proximityObserver: EPXProximityObserver!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        rooms.append("A218")
//        rooms.append("A319")
//        rooms.append("A320")
        

        // Do any additional setup after loading the view from its nib.
        
        manager.makeGetCall { (_) in
            self.tableView.reloadData()
        }
        tableView.isHidden = true
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        let cloudCredentials = EPXCloudCredentials(appID: "vampproject-k92",
                                                   appToken: "a9108116916562a1956beffbb6280d83")
        
        self.proximityObserver = EPXProximityObserver(
            credentials: cloudCredentials,
            errorBlock: { error in
                print("proximity observer error: \(error)")
        })
        
        let zone1 = EPXProximityZone(range: .near,
                                     attachmentKey: "location", attachmentValue: "mu")
        
        zone1.onChangeAction = { attachments in
            if attachments.isEmpty {
                self.roomLabel.text = "No rooms nearby!"
                self.rooms.removeAll()
            } else {
                self.roomLabel.text = "Nearby rooms: "
                let all = attachments.map { $0.payload["room"] as! String }
                //self.roomLabel.text = "Nearby rooms: " + all.joined(separator: ", ")
                self.rooms = all
            }
            
        }
        
        self.proximityObserver.startObserving([zone1])
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize)
    {
        if activeDisplayMode == .expanded
        {
            preferredContentSize = CGSize(width: 0.0, height: tableView.contentSize.height + 42)
            tableView.reloadData();
            tableView.isHidden = false
        }
        else
        {
            tableView.isHidden = true
            preferredContentSize = maxSize
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = rooms[indexPath.row]
        cell?.detailTextLabel?.text = findSubject(inRoom: rooms[indexPath.row])?.name ?? "Nothing in the room"
        return cell!
    }
    

    func findSubject(inRoom: String) -> Subject? {

        let date = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date) - 2
        let hour = myCalendar.component(.hour, from: date)
        for room in manager.rooms {
            if room.name == inRoom {
                for day in room.days {
                    if day.nameIndex == weekDay {
                        for subject in day.subjects {
                            if hour >= subject.time && hour < subject.time + 2 {
                                //print(subject.name ?? "name")
                                return subject
                            }
                        }
                    }
                }
            }
        }
        //print("nothing")
        return nil
    }
    
}
