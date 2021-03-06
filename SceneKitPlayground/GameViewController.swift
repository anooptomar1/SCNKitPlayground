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

class GameViewController: UIViewController, UIGestureRecognizerDelegate, EndGameProtocol {
    let mazeManager = MazeManager.sharedInstance
    let gameManager = GameManager()
    
    var timer = Timer()
    let timeManager = TimeManager()
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var stepLabel: UILabel!
    //SceneKit Properties
    @IBOutlet weak var sceneView: SCNView!
    let scene = SCNScene()
    let cameraNode = SCNNode()
    var lookGesture: UIPanGestureRecognizer!
    var cameraElevation: Float = 0
    var cameraDirection: Float = 0
    let size: Float = 5
    
    //TableView Properties
    var titlesArray = [MazeTile]()
    @IBOutlet weak var titlesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        //set up scene
        setUpSceneView()
        setUpCamera()
        setUpLight()
        
        //set up maze
        createMaze()
        createBorders()
        createGround()
        createEndNode()
        
        //set up game
        gameManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let position = cameraNode.position
        let moveTo = SCNAction.move(to: SCNVector3(x: position.x, y: 0, z: position.z), duration: 4)
        self.cameraNode.runAction(moveTo, completionHandler: {
            DispatchQueue.main.async {
                self.titlesTableView.isUserInteractionEnabled = true
                self.startTimer()
                self.gameManager.startGame()
                self.populateTableView()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        super.viewWillDisappear(animated)
    }
    
    func endGame() {
        timer.invalidate()
        gameManager.player.time = Int64(timeManager.stopWatch.totalTime)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "EndGameViewController", sender: nil)
        }
    }
    
    func setUpSceneView() {
        sceneView.scene = scene
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
        cameraNode.position = SCNVector3(x: startX*size, y: 20, z: startZ*size)
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
        ambientLightNode.light!.color = UIColor.lightGray
        scene.rootNode.addChildNode(ambientLightNode)
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
    
    @IBAction func quitButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
    
    func createEndNode() {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "trophy")
        let wall = createWall()
        wall.geometry?.materials = [material]
        wall.position = SCNVector3(x: (Float(mazeManager.maze.end.0))*size, y: 6, z: (Float(mazeManager.maze.end.1))*size)
        scene.rootNode.addChildNode(wall)
    }
}

extension GameViewController {
    @objc func panInView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        cameraDirection += Float(translation.x/200)
        cameraElevation += Float(translation.y/200)
        cameraNode.eulerAngles = SCNVector3(x: cameraElevation, y: cameraDirection, z: 0)
        sender.setTranslation(CGPoint(x:0, y:0), in: self.view)
    }
    
    @objc func tapInView(_ sender: UIGestureRecognizer) {
        // check what nodes are tapped
        let position = sender.location(in: sceneView)
        let hitResults = sceneView.hitTest(position, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            let node = result.node!
            
            let xPosition = Int(node.position.x/size)
            let zPosition = Int(node.position.z/size)
            
            if xPosition == gameManager.player.xPosition && zPosition == gameManager.player.zPosition {
                return
            }
            
            if !mazeManager.checkWall(x: xPosition, z: zPosition) && !mazeManager.checkBorder(x: xPosition, z: zPosition) {
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
}

extension GameViewController {
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimerLabel() {
        timeManager.addTime(timeInterval: timer.timeInterval)
        timeLabel.text = timeManager.getTimeString()
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
            var moveTo: SCNAction?
            gameManager.movePlayer(direction)
            switch direction {
            case .north:
                moveTo = SCNAction.move(to: SCNVector3(x: position.x, y: position.y, z: position.z-self.size), duration: 1)
            case .south:
                moveTo = SCNAction.move(to: SCNVector3(x: position.x, y: position.y, z: position.z+self.size), duration: 1)
            case .west:
                moveTo = SCNAction.move(to: SCNVector3(x: position.x-self.size, y: position.y, z: position.z), duration: 1)
            case .east:
                moveTo = SCNAction.move(to: SCNVector3(x: position.x+self.size, y: position.y, z: position.z), duration: 1)
            case .none:
                moveTo = nil
                tableView.isUserInteractionEnabled = true
                self.populateTableView()
            }
            
            if moveTo != nil {
                self.cameraNode.runAction(moveTo!, completionHandler: {
                    self.gameManager.checkWin()
                    DispatchQueue.main.async {
                        tableView.isUserInteractionEnabled = true
                    }
                    self.populateTableView()
                })
            }
        }
        gameManager.player.steps += 1
        stepLabel.text = "Steps: \(gameManager.player.steps)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EndGameViewController" {
            let egvc = segue.destination as! EndGameViewController
            egvc.player = gameManager.player
        }
    }
}
