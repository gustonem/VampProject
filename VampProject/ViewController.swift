//
//  ViewController.swift
//  VampProject
//
//  Created by Gusto Nemec on 16/03/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ESTBeaconManagerDelegate{
    
    let beaconManager = ESTBeaconManager()
    //let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "BFFBEC6C-E5E0-4045-9A4D-3C5814BA79B9")!, major: 1, minor: 1, identifier: "ranged region")
    
    let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "8492E75F-4FD6-469D-B132-043FE94921D8")!, identifier: "ranged region")


    override func viewDidLoad() {
        super.viewDidLoad()
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeacons(in: self.beaconRegion)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeacons(in: self.beaconRegion)
    }
    //var number = 0;
    
    func infoBeacon(_ beacon: CLBeacon) -> String? {
        //number += 1
        return "\(beacon.major):\(beacon.minor), distance: \(beacon.accuracy)"
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon],
                       in region: CLBeaconRegion) {
        if let nearestBeacon = beacons.first,
            let b = infoBeacon(nearestBeacon) {
            // TODO: update the UI here
            print(b) // TODO: remove after implementing the UI
        }
    }


}

