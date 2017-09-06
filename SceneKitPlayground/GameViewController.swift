//
//  GameViewController.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-04.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    let mazeManager = MazeManager.sharedInstance
    let scene = SCNScene()
    let cameraNode = SCNNode()
    var lookGesture: UIPanGestureRecognizer!
    var cameraElevation: Float = 0
    var cameraDirection: Float = 0
    @IBOutlet weak var sceneView: SCNView!

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mazeManager.setUp()
        setUpSceneView()
        setUpCamera()
        setUpLight()
        createMaze()
        createBorders()
    }
    
    func setUpSceneView() {
        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapInView(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        lookGesture = UIPanGestureRecognizer(target: self, action: #selector(panInView(_:)))
        lookGesture.delegate = self
        view.addGestureRecognizer(lookGesture)
    }
    
    func setUpCamera() {
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        let startX = Float(mazeManager.maze.start.0)
        let startZ = Float(mazeManager.maze.start.1)
        cameraNode.position = SCNVector3(x: startX*2-1, y: 0, z: startZ*2-1)
        cameraDirection = cameraNode.orientation.y
        cameraElevation = cameraNode.orientation.x
    }
    
    func setUpLight() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func createNode() -> SCNNode {
        let geometry = SCNSphere(radius: 1)
        return SCNNode(geometry: geometry)
    }

    func createWall() -> SCNNode {
        let geometry = SCNBox(width: 2, height: 3, length: 2, chamferRadius: 0)
        return SCNNode(geometry: geometry)
    }
    
    func createMaze() {
        let dict = mazeManager.maze.invalid
        for index in 0...9 {
            if let array = dict[index] {
                for position in array {
                    let wall = createWall()
                    wall.position = SCNVector3(x: (Float(index))*2, y: 0, z: (Float(position))*2)
                    scene.rootNode.addChildNode(wall)
                }
            }
        }
    }
    
    func createBorders() {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "cliff")

        for index in 0...11 {
            let borderWallZ = createWall()
            borderWallZ.position = SCNVector3(x: -2, y: 0, z: (Float(index)-1)*2)
            borderWallZ.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallZ)
            
            let borderWallZ2 = createWall()
            borderWallZ2.position = SCNVector3(x: 20, y: 0, z: (Float(index)-1)*2)
            borderWallZ2.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallZ2)
            
            let borderWallX = createWall()
            borderWallX.position = SCNVector3(x: (Float(index)-1)*2, y: 0, z: -2)
            borderWallX.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallX)
            
            let borderWallX2 = createWall()
            borderWallX2.position = SCNVector3(x: (Float(index)-1)*2, y: 0, z: 20)
            borderWallX2.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallX2)
        }
    }
    
    func createSky() {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "sky")

    }
    
}

extension GameViewController {
    func panInView(_ sender: UIPanGestureRecognizer) {
        
        //get translation and convert to rotation
        
        let translation = sender.translation(in: view)
        cameraDirection += Float(translation.x/300)
        cameraElevation += Float(translation.y/300)
        cameraNode.eulerAngles = SCNVector3(x: cameraElevation, y: cameraDirection, z: 0)
        sender.setTranslation(CGPoint(x:0, y:0), in: self.view)
    }
   
    func tapInView(_ sender: UIGestureRecognizer) {
        
        // check what nodes are tapped
        let p = sender.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }

    @IBAction func moveButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 1, animations: {
            let position = self.cameraNode.position
            let moveTo = SCNAction.move(to: SCNVector3(x: position.x, y: position.y+2, z: position.z), duration: 1)
            self.cameraNode.runAction(moveTo)
        })
    }
}
