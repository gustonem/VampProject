//
//  MuniMapViewController.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 25/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import Foundation

import UIKit
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
        
        let htmlFile = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "www")
        let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        webView.loadHTMLString(html!, baseURL: nil)
        
        /*let myURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)*/
    }
    
}
