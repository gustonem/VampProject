//
//  AfterScanViewController.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 28/03/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class QRMapperViewController: UIViewController {
    
    //MARK: Members
    var qrPoint: QRPoint?
    
    //MARK: Properties
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var arContainerView: UIView!

    
    override func viewDidAppear(_ animated: Bool) {
        showARLocator()
    }
    
    
    //MARK: Actions
    @IBAction func onBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onViewSwitch(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // Switch to muni map view
            showMuniMap()
            break
        case 1:
            // Switch to AR locator view
            showARLocator()
            break
        default:
            break
        }
    }
    
    //Mark: Helper methods
    func showMuniMap() {
        mapContainerView.isHidden = false
        arContainerView.isHidden  = true
    }
    
    func showARLocator() {
//        guard QRLocatorViewController.parsedScanResult != nil else { return }
        
        arContainerView.isHidden  = false
        mapContainerView.isHidden = true
    }
}
