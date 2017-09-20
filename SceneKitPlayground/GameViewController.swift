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
    let gameManager = GameManager.sharedInstance
    
    //SceneKit Properties
    @IBOutlet weak var sceneView: SCNView!
    let scene = SCNScene()
    let cameraNode = SCNNode()
    var lookGesture: UIPanGestureRecognizer!
    var cameraElevation: Float = 0
    var cameraDirection: Float = 0
    let size: Float = 5
    
    //TableView Properties
    var titlesArray = [TileObject]()
    @IBOutlet weak var titlesTableView: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //        if UIDevice.current.userInterfaceIdiom == .phone {
    //            return .allButUpsideDown
    //        } else {
    //            return .all
    //        }
    //    }
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up scene
        setUpSceneView()
        setUpCamera()
        setUpLight()
        
        //set up maze
        createMaze()
        createBorders()
        // createSky()
        createGround()
        
        //set up game
        gameManager.startGame()
        populateTableView()
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
        let camera = SCNCamera()
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
        let maze = mazeManager.maze
        let startX = Float(maze.start.0)
        let startZ = Float(maze.start.1)
        cameraNode.position = SCNVector3(x: startX*size, y: 0, z: startZ*size)
        cameraDirection = Float.pi/2 * Float(maze.startFacing.rawValue)
        cameraElevation = cameraNode.orientation.x
        cameraNode.eulerAngles = SCNVector3(x: cameraElevation, y: cameraDirection, z: 0)
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
        let geometry = SCNBox(width: CGFloat(size), height: 3, length: CGFloat(size), chamferRadius: 0.05)
        return SCNNode(geometry: geometry)
    }
    
    func createMaze() {
        let dict = mazeManager.maze.invalid
        for zIndex in 0...9 {
            if let array = dict[zIndex] {
                for xIndex in array {
                    let material = SCNMaterial()
                    material.diffuse.contents = UIImage(named: "hedge")
                    let wall = createWall()
                    wall.geometry?.materials = [material]
                    wall.position = SCNVector3(x: (Float(xIndex))*size, y: 0, z: (Float(zIndex))*size)
                    scene.rootNode.addChildNode(wall)
                }
            }
        }
    }
    
    func createBorders() {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "cliff")
        
        for index in -1...10 {
            let borderWallZ = createWall()
            borderWallZ.position = SCNVector3(x: -size, y: 0, z: Float(index)*size)
            borderWallZ.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallZ)
            
            let borderWallZ2 = createWall()
            borderWallZ2.position = SCNVector3(x: 10 * size, y: 0, z: Float(index)*size)
            borderWallZ2.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallZ2)
            
            let borderWallX = createWall()
            borderWallX.position = SCNVector3(x: Float(index)*size, y: 0, z: -size)
            borderWallX.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallX)
            
            let borderWallX2 = createWall()
            borderWallX2.position = SCNVector3(x: Float(index)*size, y: 0, z: 10 * size)
            borderWallX2.geometry?.materials = [material]
            scene.rootNode.addChildNode(borderWallX2)
        }
    }
    
    func createSky() {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "sky")
        let geometry = SCNBox(width: 24, height: 1, length: 24, chamferRadius: 0)
        let skyBox = SCNNode(geometry: geometry)
        scene.rootNode.addChildNode(skyBox)
        skyBox.position = SCNVector3(x: 9, y: 2, z: 9)
        skyBox.geometry?.materials = [material]
    }
    
    func createGround() {
        for xIndex in 0...9 {
            for zIndex in 0...9 {
                let tile = mazeManager.mazeArray[xIndex][zIndex]
                let material = SCNMaterial()
                let image = UIImage(data: tile.image! as Data)
                material.diffuse.contents = image
                let wall = createWall()
                wall.geometry?.materials = [material]
                wall.position = SCNVector3(x: (Float(xIndex))*size, y: -3, z: (Float(zIndex))*size)
                scene.rootNode.addChildNode(wall)
            }
        }
    }
}

extension GameViewController {
    func panInView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        cameraDirection += Float(translation.x/200)
        cameraElevation += Float(translation.y/200)
        cameraNode.eulerAngles = SCNVector3(x: cameraElevation, y: cameraDirection, z: 0)
        sender.setTranslation(CGPoint(x:0, y:0), in: self.view)
    }
    
    func tapInView(_ sender: UIGestureRecognizer) {
        // check what nodes are tapped
        let position = sender.location(in: sceneView)
        let hitResults = sceneView.hitTest(position, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            let node = result.node!
            
            let xPosition = node.position.x
            let zPosition = node.position.z
            
            if mazeManager.checkValid(x: Int(xPosition/size), z: Int(zPosition/size)) {
                moveNodeIntoView(node: node)
            }
        }
    }
    
    func moveNodeIntoView(node: SCNNode) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        node.position = SCNVector3(x: node.position.x, y: 0, z: node.position.z)
        
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.0
            node.position = SCNVector3(x: node.position.x, y: -3, z: node.position.z)
            SCNTransaction.commit()
        }
        SCNTransaction.commit()
    }
    
    @IBAction func moveXPressed(_ sender: UIButton) {
        //east
        UIView.animate(withDuration: 1, animations: {
            let position = self.cameraNode.position
            let moveTo = SCNAction.move(to: SCNVector3(x: position.x+self.size, y: position.y, z: position.z), duration: 1)
            self.cameraNode.runAction(moveTo)
        })
    }
    
    @IBAction func moveReverseXPressed(_ sender: UIButton) {
        //west
        UIView.animate(withDuration: 1, animations: {
            let position = self.cameraNode.position
            let moveTo = SCNAction.move(to: SCNVector3(x: position.x-self.size, y: position.y, z: position.z), duration: 1)
            self.cameraNode.runAction(moveTo)
        })
    }
    
    @IBAction func moveYPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 1, animations: {
            let position = self.cameraNode.position
            let moveTo = SCNAction.move(to: SCNVector3(x: position.x, y: position.y+2, z: position.z), duration: 1)
            self.cameraNode.runAction(moveTo)
        })
    }
    
    @IBAction func moveReverseYPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 1, animations: {
            let position = self.cameraNode.position
            let moveTo = SCNAction.move(to: SCNVector3(x: position.x, y: position.y-2, z: position.z), duration: 1)
            self.cameraNode.runAction(moveTo)
        })
    }
    
    @IBAction func moveZPressed(_ sender: UIButton) {
        //south
        UIView.animate(withDuration: 1, animations: {
            let position = self.cameraNode.position
            let moveTo = SCNAction.move(to: SCNVector3(x: position.x, y: position.y, z: position.z+self.size), duration: 1)
            self.cameraNode.runAction(moveTo)
        })
    }
    
    @IBAction func moveReverseZPressed(_ sender: UIButton) {
        //north
        UIView.animate(withDuration: 1, animations: {
            let position = self.cameraNode.position
            let moveTo = SCNAction.move(to: SCNVector3(x: position.x, y: position.y, z: position.z-self.size), duration: 1)
            self.cameraNode.runAction(moveTo)
        })
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
        let tile = titlesArray[indexPath.row]
        var title = tile.title
        if title == nil || title == "" {
            title = "Unnamed"
        }
        
        cell.titleLabel.text = title!
        cell.tile = tile
        return cell
    }
    
    func populateTableView() {
        titlesArray = gameManager.getSurroundingTileTitles()
        DispatchQueue.main.async {
            self.titlesTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TitleCell
        if let direction = gameManager.surroundingTilesDictionary[cell.tile] {
            tableView.isUserInteractionEnabled = false
            let position = self.cameraNode.position
            var moveTo: SCNAction
            switch direction {
            case .north:
                gameManager.movePlayerNorth()
                moveTo = SCNAction.move(to: SCNVector3(x: position.x, y: position.y, z: position.z-self.size), duration: 1)
            case .south:
                gameManager.movePlayerSouth()
                moveTo = SCNAction.move(to: SCNVector3(x: position.x, y: position.y, z: position.z+self.size), duration: 1)
            case .west:
                gameManager.movePlayerWest()
                moveTo = SCNAction.move(to: SCNVector3(x: position.x-self.size, y: position.y, z: position.z), duration: 1)
            case .east:
                gameManager.movePlayerEast()
                moveTo = SCNAction.move(to: SCNVector3(x: position.x+self.size, y: position.y, z: position.z), duration: 1)
            }
            self.cameraNode.runAction(moveTo, completionHandler: {
                tableView.isUserInteractionEnabled = true
                self.populateTableView()
            })
        }
    }
}
