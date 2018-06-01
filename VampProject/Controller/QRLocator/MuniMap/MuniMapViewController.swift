//
//  MuniMapViewController.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 25/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//


import os.log
import UIKit
import ARKit
import WebKit

class MuniMapViewController: UIViewController, WKUIDelegate {
    
    let baseMuniMapUrl: String! = "http://server-smart-university.a3c1.starter-us-west-1.openshiftapps.com/munimap"
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let scannedPoint = self.getScannedPoint() else {
            // TODO close self
            return
        }
        
        let muniMapId = scannedPoint.getMuniMapId() // TODO implement
        let muniMapRequest = URLRequest(url: URL(string: baseMuniMapUrl)!)
        
        webView.load(muniMapRequest)
    }
    
    func getScannedPoint() -> QRPoint? {
        guard let scannerVc = self.parent as? QRMapperViewController else {
            return nil
        }
        
        return scannerVc.qrPoint
    }
}
