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

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var roomLabel: UILabel!
    
    var proximityObserver: EPXProximityObserver!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
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
            } else {
                //self.roomLabel.text = "Nearby rooms: "
                let a = attachments.map { $0.payload["room"] as! String }
                //self.roomLabel.text?.append(a.joined(separator: ", "))
                self.roomLabel.text = "Nearby rooms: " + a.joined(separator: ", ")
            }
            
        }
        
        self.proximityObserver.startObserving([zone1])
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
    
}
