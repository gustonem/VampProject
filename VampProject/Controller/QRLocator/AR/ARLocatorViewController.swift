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
//    var anchors = [ARAnchor]()
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        os_log("ARLocatorViewController: renderer called")
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        DispatchQueue.main.async {
            
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.25
            
            /*
             `SCNPlane` is vertically oriented in its local coordinate space, but
             `ARImageAnchor` assumes the image is horizontal in its local space, so
             rotate the plane to match.
             */
            planeNode.eulerAngles.x = -.pi / 2
            
            /*
             Image anchors are not tracked after initial detection, so create an
             animation that limits the duration for which the plane visualization appears.
             */
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
//                geometryNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "./art.scnassets/wood.png")
//                geometryNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
//                geometryNode.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
//                geometryNode.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat
//                geometryNode.geometry?.firstMaterial?.diffuse.mipFilter = SCNFilterMode.linear
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
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
}












//
//import ARKit
//
//class ARLocatorViewController: UIViewController, ARSKViewDelegate {
//
//    var sceneView: ARSKView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if let view = self.view as? ARSKView {
//            sceneView           = view
//            sceneView!.delegate = self
//            let scene           = LocatorScene(size: view.bounds.size)
//            scene.scaleMode     = .resizeFill
//            scene.anchorPoint   = CGPoint(x: 0.5, y: 0.5)
//            view.presentScene(scene)
//            view.showsFPS       = true
//            view.showsNodeCount = true
//        }
//    }
//
////    func view(_ view: ARSKView,
////              nodeFor anchor: ARAnchor) -> SKNode? {
////        let bug = SKSpriteNode(imageNamed: "bug")
////        bug.name = "bug"
////        return bug
////    }
//
//    func session(_ session: ARSession,
//                 didFailWithError error: Error) {
//        print("Session Failed - probably due to lack of camera access")
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        print("Session interrupted")
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        print("Session resumed")
//
//        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
//            fatalError("Missing expected asset catalog resources.")
//        }
//
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.detectionImages = referenceImages
//        sceneView.session.run(configuration,
//                              options: [.resetTracking,
//                                        .removeExistingAnchors])
////        sceneView.session.run(session.configuration!,
////                              options: [.resetTracking,
////                                        .removeExistingAnchors])
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let configuration = ARWorldTrackingConfiguration()
//        sceneView.session.run(configuration)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        sceneView.session.pause()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Release any cached data, images, etc that aren't in use.
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//}
