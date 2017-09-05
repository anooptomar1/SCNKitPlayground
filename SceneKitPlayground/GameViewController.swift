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

class GameViewController: UIViewController {
    let mazeManager = MazeManager.sharedInstance
    let scene = SCNScene()
    let cameraNode = SCNNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        mazeManager.setUp()
        // create and add a camera to the scene
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        createMaze()
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func createNode() -> SCNNode {
        let geometry = SCNSphere(radius: 1)
        return SCNNode(geometry: geometry)
    }

    func createWall() -> SCNNode {
        let geometry = SCNBox(width: 1, height: 3, length: 1, chamferRadius: 0)
        return SCNNode(geometry: geometry)
    }
    
    func createMaze() {
        
        let dict = mazeManager.maze.invalid
        for index in 0...9 {
            if let array = dict[index] {
                for position in array {
                    let wall = createWall()
                    wall.position = SCNVector3(x: Float(index), y: 0, z: Float(position))
                    scene.rootNode.addChildNode(wall)
                }
            }
        }
        
        
        createBorders()
        // place the camera
        let startX = Float(mazeManager.maze.start.0)
        let startZ = Float(mazeManager.maze.start.1)
        let startWall = createWall()
        startWall.position = SCNVector3(x: startX, y: 0, z: startZ)
        scene.rootNode.addChildNode(startWall)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "cliff")
        startWall.geometry?.materials = [material]
        
        cameraNode.position = SCNVector3(x: startX, y: 0, z: startZ)
    }
    
    func createBorders() {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "cliff")

        for index in 0...11 {
            let borderWallZ = createWall()
            borderWallZ.position = SCNVector3(x: -1, y: 0, z: Float(index)-1)
            borderWallZ.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallZ)
            
            let borderWallZ2 = createWall()
            borderWallZ2.position = SCNVector3(x: 10, y: 0, z: Float(index)-1)
            borderWallZ2.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallZ2)
            
            let borderWallX = createWall()
            borderWallX.position = SCNVector3(x: Float(index)-1, y: 0, z: -1)
            borderWallX.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallX)
            
            let borderWallX2 = createWall()
            borderWallX2.position = SCNVector3(x: Float(index)-1, y: 0, z: 10)
            borderWallX2.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallX2)
        }
    }
}
