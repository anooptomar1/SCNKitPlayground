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
    
    func startGame() {
        player = dataManager.generatePlayer()
        player.xPosition = Int16(mazeManager.maze.start.0)
        player.zPosition = Int16(mazeManager.maze.start.1)
        player.steps = 0
    }
    
    func getSurroundingTileTitles() -> [MazeTile] {
        getSurroundingTiles(x: Int(player.xPosition), z: Int(player.zPosition))
        return randomizeSurrounding()
    }
    
    func getSurroundingTiles(x: Int, z: Int) {
        surroundingTilesDictionary.removeAll()
        let tiles = mazeManager.mazeArray
        
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
    
    func randomizeSurrounding() -> [MazeTile] {
        var surroundingTiles = Array(surroundingTilesDictionary.keys)
        for index in 0..<surroundingTiles.count-1 {
            let randomIndex = Int(arc4random_uniform(UInt32((surroundingTiles.count) - index))) + index
            if index != randomIndex {
                surroundingTiles.swapAt(index, randomIndex)
            }
        }
        return surroundingTiles
    }
    
    func movePlayerNorth() {
        player.zPosition -= 1
    }
    
    func movePlayerSouth() {
        player.zPosition += 1
    }
    
    func movePlayerWest() {
        player.xPosition -= 1
    }
    
    func movePlayerEast() {
        player.xPosition += 1
    }
}
