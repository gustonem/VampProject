//
//  ViewController.swift
//  VampProject
//
//  Created by Gusto Nemec on 16/03/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class MainViewController: UIViewController, ESTBeaconManagerDelegate, QRCodeReaderViewControllerDelegate {
    
    //MARK: Properties
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader          = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    //MARK: Beacon
    //TODO please comment...
    
    let beaconManager = ESTBeaconManager()
    //let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "BFFBEC6C-E5E0-4045-9A4D-3C5814BA79B9")!, major: 1, minor: 1, identifier: "ranged region")
    
    let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "8492E75F-4FD6-469D-B132-043FE94921D8")!, identifier: "ranged region")

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
    
    //MARK: Actions
    
    @IBAction func onClickScanQr(_ sender: UIButton) {
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                self.afterScan(result: result)
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    
    //Mark: QR related
    
    func afterScan(result:QRCodeReaderResult) {
        //Show contents popup DEBUG REMOVE
        print("Completion with result: \(result.value) of type \(result.metadataType)")
        
        //Launch AfterScan screen
        performSegue(withIdentifier: "mainToAfterScan", sender: nil)
        return
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AfterScanID") as! AfterScanViewController
        self.present(vc, animated: true, completion: nil)*/
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    //Mark: Helper methods
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    //MARK: View life-cycle
    
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

}

