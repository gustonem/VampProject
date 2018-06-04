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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupSegmentedControl()
        
        updateView()
    }
    
    //MARK: Actions
    @IBAction func onBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "AR View", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Map", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc
    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: mapViewController)
            add(asChildViewController: arViewController)
        } else {
            remove(asChildViewController: arViewController)
            add(asChildViewController: mapViewController)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private lazy var mapViewController: MuniMapViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MuniMapViewController") as! MuniMapViewController
        
//        // Add View Controller as Child View Controller
//        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var arViewController: ARLocatorViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "ARLocatorViewController") as! ARLocatorViewController
        
//        // Add View Controller as Child View Controller
//        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
}

