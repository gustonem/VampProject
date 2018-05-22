//
//  LocatorScene.swift
//  VampProject
//
//  Created by Tomáš Skýpala on 01/05/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import ARKit

class LocatorScene: SKScene {
    
    
    var isWorldSetUp = false
    var sight: SKSpriteNode!
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !isWorldSetUp {
            setUpWorld()
        }
        
        // 1 Retrieve the light estimate from the session’s current frame
        guard let currentFrame  = sceneView.session.currentFrame,
            let lightEstimate       = currentFrame.lightEstimate else {
                return
        }
        
        // 2 Calculate a blend factor between 0 and 1, where 0 will be the brightest
        let neutralIntensity: CGFloat = 1000 // fairly bright light
        let ambientIntensity          = min(lightEstimate.ambientIntensity,
                                              neutralIntensity)
        let blendFactor               = 1 - ambientIntensity / neutralIntensity
        
        // 3 Calculate how much black should tint the bugs
        for node in children {
            if let bug      = node as? SKSpriteNode {
                bug.color            = .black
                bug.colorBlendFactor = blendFactor
            }
        }
    }
    
    private func setUpWorld() {
        guard let currentFrame = sceneView.session.currentFrame
            else { return }
        
        // Create translation matrix
        var translation         = matrix_identity_float4x4
        // Anchor 0.3m in front
        translation.columns.3.z = -0.3
        
        // Apply translation matrix, create transformation
        let transform           = currentFrame.camera.transform * translation
        // Create anchor with transformation
        let anchor              = ARAnchor(transform: transform)
        
        // Add anchor to scene
        sceneView.session.add(anchor: anchor)
        
        isWorldSetUp = true
    }
    
    override func didMove(to view: SKView) {
        // Add sight in center of screen
//        sight = SKSpriteNode(imageNamed: "sight")
//        addChild(sight)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
//        // Retrieve an array of all the nodes that intersect the same xy location as the sight
//        let location = sight.position
//        let hitNodes = nodes(at: location)
//
//        // Check hit nodes
//        var hitBug: SKNode?
//        for node in hitNodes {
//            // Check if is bug
//            if node.name == "bug" {
//                hitBug = node
//                break
//            }
//        }
        
    }
}
