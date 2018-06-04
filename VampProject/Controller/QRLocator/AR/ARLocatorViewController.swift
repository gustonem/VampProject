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
    
    var hasSetWorldOrigin = false
    var isPlaneSelected = false
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        guard let scannedPoint = self.getScannedPoint() else {
            return
        }
        
        if !hasSetWorldOrigin {
            hasSetWorldOrigin = true
            
            var transform = matrix_float4x4()
            
            let positions = imageAnchor.transform.columns.3
            transform.columns.3 = [positions.x, positions.y, positions.z, 1.0]
            transform.columns.2 = [0.0, 0.0, 1.0, 0.0]
            transform.columns.1 = [0.0, 1.0, 0.0, 0.0]
            transform.columns.0 = [1.0, 0.0, 0.0, 0.0]
            sceneView.session.setWorldOrigin(relativeTransform: transform)
            sceneView.session.setWorldOrigin(relativeTransform: transform)
            
            let referenceImage = imageAnchor.referenceImage
            
            drawPosterAsync(node: node, referenceImage: referenceImage)
            addRoomsAsync(rooms: scannedPoint.rooms)
        }
    }
    
    func drawPosterAsync(node: SCNNode, referenceImage: ARReferenceImage) {
        DispatchQueue.main.async {
            
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage.physicalSize.width * 1.5,
                                 height: referenceImage.physicalSize.height * 1.5)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 1
            plane.materials = [SCNMaterial()]
            
//            let pointLabel = scannedPoint.label // TODO implement
            
            plane.materials[0].diffuse.contents = UIImage(named: "Point FI MUNI Main Hall")!
            
            planeNode.eulerAngles.x = -.pi / 2
            
            // planeNode.runAction(self.imageHighlightAction)
            
            // Add the plane visualization to the scene.
            node.addChildNode(planeNode)
        }
    }
    
    func addRoomsAsync(rooms: [ARRoom]) {
        
        DispatchQueue.main.async {
            for room in rooms {
                self.sceneView.scene.rootNode.addChildNode(
                    self.getRoomNode(widthMeters: room.dimensions.width, heightMeters: room.dimensions.height, lenghtMeters: room.dimensions.length,
                                     rightMeters: room.position.right!, upMeters: room.position.up!, frontMeters: room.position.front!))
            }
        }
    }
    
    func getRoomNode(widthMeters: CGFloat, heightMeters: CGFloat, lenghtMeters: CGFloat,
                     rightMeters: CGFloat, upMeters: CGFloat, frontMeters: CGFloat) -> SCNNode {
        let cubeNode = SCNNode(geometry: getMeshBox(width: widthMeters, height: heightMeters, length:
            lenghtMeters, chamferRadius: 0))
        cubeNode.position = SCNVector3(rightMeters, upMeters, -frontMeters) // SceneKit/AR coordinates are in meters
        cubeNode.runAction(self.objectHighlightAction)
        return cubeNode
    }
    
    func getMeshBox(width: CGFloat, height: CGFloat, length: CGFloat, chamferRadius: CGFloat) -> SCNBox {
        
        let sm = "float u = _surface.diffuseTexcoord.x; \n" +
            "float v = _surface.diffuseTexcoord.y; \n" +
            "int u100 = int(u * 100); \n" +
            "int v100 = int(v * 100); \n" +
            "if (u100 % 99 == 0 || v100 % 99 == 0) { \n" +
            "  // do nothing \n" +
            "} else { \n" +
            "    discard_fragment(); \n" +
        "} \n"
        
        let box = getBox(width: width, height: height, length: length, chamferRadius: chamferRadius)
        
        box.firstMaterial?.emission.contents = UIColor.green
        box.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: sm]
        box.firstMaterial?.isDoubleSided = true
        
        return box
    }
    
    func getBox(width: CGFloat, height: CGFloat, length: CGFloat, chamferRadius: CGFloat) -> SCNBox {

        let box = SCNBox(width: width, height:height, length: length, chamferRadius: chamferRadius)
        
        let hue:CGFloat = 0.6
        let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        
        box.firstMaterial?.diffuse.contents = color
        box.firstMaterial?.transparency = 0.8
        
        return box
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.delegate = self
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func getScannedPoint() -> QRPoint? {
        guard let scannerVc = self.parent as? QRMapperViewController else {
            return nil
        }
        
        return scannerVc.qrPoint
    }
    
    var objectHighlightAction: SCNAction {
        let dur = 0.50
        let toUp:CGFloat = 0.85
        let toDown:CGFloat = 0.15
        return .sequence([
            .wait(duration: dur * 2),
            .fadeOpacity(to: toUp, duration: dur),
            .fadeOpacity(to: toDown, duration: dur),
            .fadeOpacity(to: toUp, duration: dur),
            .fadeOpacity(to: toDown, duration: dur),
            .fadeOpacity(to: toUp, duration: dur),
            .fadeOpacity(to: toDown, duration: dur),
            .fadeOpacity(to: toUp, duration: dur),
            .fadeOpacity(to: toDown, duration: dur),
            .fadeIn(duration: dur)
            ])
    }
}




//override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    os_log("ARLocatorViewController: touches began")
//    let touch = touches.first!
//    let location = touch.location(in: sceneView)
//    if !isPlaneSelected {
//        selectExistingPlane(location: location)
//    } else {
//        //            addNodeAtLocation(location: location)
//    }
//}
//
//
//func selectExistingPlane(location: CGPoint) {
//    let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingGeometry)
//    if hitResults.count > 0 {
//        os_log("ARLocatorViewController: plane hit test successful")
//        let result: ARHitTestResult = hitResults.first!
//        if let imageAnchor = result.anchor as? ARImageAnchor {
//            //                for var index in 0...anchors.count - 1 {
//            //
//            //                    if anchors[index].identifier != imageAnchor.identifier {
//            //                        sceneView.node(for: anchors[index])?.removeFromParentNode()
//            //                        sceneView.session.remove(anchor: anchors[index])
//            //                    }
//            //                    index += 1
//            //                }
//            //
//            //                anchors = [imageAnchor]
//
//            isPlaneSelected = true
//            os_log("ARLocatorViewController: plane selected!")
//
//            setPlaneTexture(node: sceneView.node(for: imageAnchor)!)
//        }
//    }
//}

