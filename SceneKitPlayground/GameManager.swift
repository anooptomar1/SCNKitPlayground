//
//  GameManager.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-20.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class GameManager: NSObject {

    let mazeManager = MazeManager.sharedInstance
    let dataManager = DataManager.sharedInstance
    var player: PlayerObject!
    var surroundingTilesDictionary = [MazeTile: Direction]()
    var delegate: EndGameProtocol!

    func startGame() {
        player = dataManager.generatePlayer()
        player.xPosition = Int16(mazeManager.maze.start.0)
        player.zPosition = Int16(mazeManager.maze.start.1)
        player.steps = 0
    }
    
    func endGame() {
        delegate.endGame()
    }
    
    func getSurroundingTileTitles() -> [MazeTile] {
        getSurroundingTiles(x: Int(player.xPosition), z: Int(player.zPosition))
        return randomizeArray(Array(surroundingTilesDictionary.keys)) as! Array<MazeTile>
    }
    
    func getSurroundingTiles(x: Int, z: Int) {
        surroundingTilesDictionary.removeAll()
        let tiles = mazeManager.mazeArray
        //checks the four tiles around the player position in the order north, south, west, east
        //if the tile is on a border, nothing is returned
        //the values of the dictionary represent which direction the player will move if that tile is selected. The direction is set to none if the tile contains a wall.
        if !mazeManager.checkBorder(x: x, z: z-1) {
            if !mazeManager.checkWall(x: x, z: z-1) {
                surroundingTilesDictionary.updateValue(.north, forKey: tiles[x][z-1])
            } else {
                surroundingTilesDictionary.updateValue(.none, forKey: tiles[x][z-1])
            }
        }
        
        if !mazeManager.checkBorder(x: x, z: z+1) {
            if !mazeManager.checkWall(x: x, z: z+1) {
                surroundingTilesDictionary.updateValue(.south, forKey: tiles[x][z+1])
            } else {
                surroundingTilesDictionary.updateValue(.none, forKey: tiles[x][z+1])
            }
        }
        
        if !mazeManager.checkBorder(x: x-1, z: z) {
            if !mazeManager.checkWall(x: x-1, z: z) {
                surroundingTilesDictionary.updateValue(.west, forKey: tiles[x-1][z])
            } else {
                surroundingTilesDictionary.updateValue(.none, forKey: tiles[x-1][z])
            }
        }

        if !mazeManager.checkBorder(x: x+1, z: z) {
            if !mazeManager.checkWall(x: x+1, z: z) {
                surroundingTilesDictionary.updateValue(.east, forKey: tiles[x+1][z])
            } else {
                surroundingTilesDictionary.updateValue(.none, forKey: tiles[x+1][z])
            }
        }
    }
    
    func randomizeArray(_ array: Array<Any>) -> Array<Any> {
        var randomArray = array
        for index in 0..<randomArray.count-1 {
            let randomIndex = Int(arc4random_uniform(UInt32((randomArray.count) - index))) + index
            if index != randomIndex {
                randomArray.swapAt(index, randomIndex)
            }
        }
        return randomArray
    }
    
    func movePlayer(_ direction: Direction) {
        switch direction {
        case .north:
            player.zPosition -= 1
        case .south:
            player.zPosition += 1
        case .west:
            player.xPosition -= 1
        case .east:
            player.xPosition += 1
        default:
            break
        }
    }
    
    func checkWin() {
        if player.xPosition == mazeManager.maze.end.0 && player.zPosition == mazeManager.maze.end.1 {
            endGame()
        }
    }
}
