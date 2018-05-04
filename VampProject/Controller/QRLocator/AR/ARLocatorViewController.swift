//
//  ARLocatorViewController.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 01/05/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import os.log
import UIKit
import ARKit

class ARLocatorViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var isPlaneSelected = false
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        DispatchQueue.main.async {
            
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage.physicalSize.width * 1.5,
                                 height: referenceImage.physicalSize.height * 1.5)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 1
            
            plane.materials = [SCNMaterial()]
            plane.materials[0].diffuse.contents = UIImage(named: "Point FI MUNI Main Hall")
            
            planeNode.eulerAngles.x = -.pi / 2
            
//            planeNode.runAction(self.imageHighlightAction)
            
            // Add the plane visualization to the scene.
            node.addChildNode(planeNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        os_log("ARLocatorViewController: touches began")
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        if !isPlaneSelected {
            selectExistingPlane(location: location)
        } else {
//            addNodeAtLocation(location: location)
        }
    }
    
    
    func selectExistingPlane(location: CGPoint) {
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingGeometry)
        if hitResults.count > 0 {
            os_log("ARLocatorViewController: plane hit test successful")
            let result: ARHitTestResult = hitResults.first!
            if let imageAnchor = result.anchor as? ARImageAnchor {
//                for var index in 0...anchors.count - 1 {
//
//                    if anchors[index].identifier != imageAnchor.identifier {
//                        sceneView.node(for: anchors[index])?.removeFromParentNode()
//                        sceneView.session.remove(anchor: anchors[index])
//                    }
//                    index += 1
//                }
//
//                anchors = [imageAnchor]
                
                isPlaneSelected = true
                os_log("ARLocatorViewController: plane selected!")
                
                setPlaneTexture(node: sceneView.node(for: imageAnchor)!)
            }
        }
    }
    
    func setPlaneTexture(node: SCNNode) {
        if let geometryNode = node.childNodes.first {
            if node.childNodes.count > 0 {
                geometryNode.removeFromParentNode()
            }
        }
    }
    
    func resetTracking() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
}
