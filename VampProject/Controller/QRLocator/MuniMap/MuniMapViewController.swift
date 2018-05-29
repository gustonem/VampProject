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
        let muniMapRequest = URLRequest(url: URL(string: "08668375-551f-4033-a3b8-f1f6715dfb79.htmlpasta.com/")!)
        
        webView.load(muniMapRequest)
    }
    
    func getScannedPoint() -> QRPoint? {
        guard let scannerVc = self.parent as? QRMapperViewController else {
            return nil
        }
        
        return scannerVc.qrPoint
    }
}
