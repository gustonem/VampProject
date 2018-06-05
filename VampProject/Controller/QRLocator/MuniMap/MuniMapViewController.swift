//
//  MuniMapViewController.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 25/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit

class MuniMapViewController: UIViewController {
    
    let baseMuniMapUrl: String! = "http://server-smart-university.a3c1.starter-us-west-1.openshiftapps.com/munimap"
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let urlQuery : String
        if let scannedPoint = self.getScannedPoint() {
            urlQuery = "?id=\(scannedPoint.muniMapId)"
        } else {
            urlQuery = ""
        }

        let myWebView:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let url = URL (string: baseMuniMapUrl + urlQuery);
        let request = URLRequest(url: url! as URL);
        myWebView.loadRequest(request);
        self.view.addSubview(myWebView)
    }
    
    func getScannedPoint() -> QRPoint? {
        guard let scannerVc = self.parent as? QRMapperViewController else {
            return nil
        }
        
        return scannerVc.qrPoint
    }
}
