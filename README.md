# Tap Gesture

1) Create figure

```
 private func createFigures(in scene: SCNScene) {
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor.red
        boxMaterial.specular.contents = UIColor.yellow
        
        let boxNode = SCNNode(geometry: box)
        boxNode.geometry?.materials = [boxMaterial]
        boxNode.position = SCNVector3(0.0, 0.0, -1.0)
        scene.rootNode.addChildNode(boxNode)
    }
```
2) Add gesture recognaizer

```
 let gestureRecognaizer = UITapGestureRecognizer(target: self, action: #selector(boxTapped(touch:)))
 self.sceneView.addGestureRecognizer(gestureRecognaizer)
```

3) Action box tapped

```
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

```

## Button action

1) Add scene view session
```
var session: ARSession {
   return sceneView.session
}
```
2) Reset Tapped

```
 
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
```
3) add tapped

```
 @IBAction func addTapped(sender: UIButton) {
     createFigures(in: sceneView.scene)
 }
```


