//
//  AfterScanViewController.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 28/03/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation
import UIKit
import QRCodeReader
import AVFoundation

class QRLocatorViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    //MARK: Static
    private static var parsedScanResult: String? = nil
    
    //MARK: Properties
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var arContainerView: UIView!
    
    
    //Mark: Members
    lazy var reader: QRCodeReader                 = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder     = QRCodeReaderViewControllerBuilder {
            $0.reader                        = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton               = true
            
            $0.reader
                .stopScanningWhenCodeIsFound = true
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        mapContainerView.isHidden = true
        arContainerView.isHidden  = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showARLocator()
    }
    
    
    //MARK: Actions
    @IBAction func reScanClick(_ sender: UIButton) {
        startQRScan()
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
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert   = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL  = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert   = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    func showMuniMap() {
        mapContainerView.isHidden = false
        arContainerView.isHidden  = true
    }
    
    func showARLocator() {
//        guard QRLocatorViewController.parsedScanResult != nil else { return }
        
        arContainerView.isHidden  = false
        mapContainerView.isHidden = true
    }
    
    //Mark: QR related
    
    func startQRScan() {
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock        = { (result: QRCodeReaderResult?) in
            if let result = result {
                self.afterScan(scanResult: result)
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    
    func afterScan(scanResult:QRCodeReaderResult) {
        //Show contents popup TODO DEBUG REMOVE
        print("Completion with result: \(scanResult.value) of type \(scanResult.metadataType)")
        
        QRLocatorViewController.parsedScanResult = parseScanResult(scanResult: scanResult)
        
        reader.stopScanning()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.showARLocator()
        })
    }
    
    func parseScanResult(scanResult: QRCodeReaderResult) -> String {
        return scanResult.value
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
            let alert        = UIAlertController(
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
}
