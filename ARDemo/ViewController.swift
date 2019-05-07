//
//  ViewController.swift
//  ARDemo
//
//  Created by Maxim Spiridonov on 06/05/2019.
//  Copyright © 2019 Maxim Spiridonov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    var session: ARSession {
        return sceneView.session
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
      
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        let gestureRecognaizer = UITapGestureRecognizer(target: self, action: #selector(boxTapped(touch:)))
        self.sceneView.addGestureRecognizer(gestureRecognaizer)

    }
    
    @objc func boxTapped(touch: UITapGestureRecognizer) {
        
        let sceneView = touch.view as! SCNView
        let touchLocation = touch.location(in: sceneView)
        
        let touchResults = sceneView.hitTest(touchLocation, options: [:])
        
        guard !touchResults.isEmpty, let node = touchResults.first?.node else { return }
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor.blue
        boxMaterial.specular.contents = UIColor.red
        node.geometry?.materials[0] = boxMaterial
    }
    
    private func createFigures(in scene: SCNScene) {
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor.red
        boxMaterial.specular.contents = UIColor.yellow
        
        let boxNode = SCNNode(geometry: box)
        boxNode.name = "box"
        boxNode.geometry?.materials = [boxMaterial]
        boxNode.position = SCNVector3(0.0, 0.0, -0.5)
        scene.rootNode.addChildNode(boxNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func resetTapped(sender: UIButton) {
        session.pause()
        sceneView.scene.rootNode.enumerateChildNodes {  (node,_) in
            if node.name == "box" {
                node.removeFromParentNode()
            }
        }
        let configuration = ARWorldTrackingConfiguration()
        session.run(configuration, options: [.resetTracking, .resetTracking])
    }
    @IBAction func addTapped(sender: UIButton) {
        createFigures(in: sceneView.scene)
    }
}
