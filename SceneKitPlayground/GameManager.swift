//
//  GameManager.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-20.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class GameManager: NSObject {
    static let sharedInstance = GameManager()
    private override init() {}
    
    let mazeManager = MazeManager.sharedInstance
    let dataManager = DataManager.sharedInstance
    var player: PlayerObject!
    var surroundingTilesDictionary = [TileObject: Direction]()
    func startGame() {
        player = dataManager.generatePlayer()
        player.xPosition = Int16(mazeManager.maze.start.0)
        player.zPosition = Int16(mazeManager.maze.start.1)
    }
    
    func getSurroundingTileTitles() -> [TileObject] {
        getSurroundingTiles(x: Int(player.xPosition), z: Int(player.zPosition))
        return randomizeSurrounding()
    }
    
    func getSurroundingTiles(x: Int, z: Int) {
        surroundingTilesDictionary.removeAll()
        let tiles = mazeManager.mazeArray
        
        if mazeManager.checkValid(x: x, z: z-1) {
            surroundingTilesDictionary.updateValue(.north, forKey: tiles[x][z-1])
        }
        
        if mazeManager.checkValid(x: x, z: z+1) {
            surroundingTilesDictionary.updateValue(.south, forKey: tiles[x][z+1])
        }
        
        if mazeManager.checkValid(x: x-1, z: z) {
            surroundingTilesDictionary.updateValue(.west, forKey: tiles[x-1][z])
        }
        
        if mazeManager.checkValid(x: x+1, z: z) {
            surroundingTilesDictionary.updateValue(.east, forKey: tiles[x+1][z])
        }
    }
    
    func randomizeSurrounding() -> [TileObject] {
        var surroundingTiles = Array(surroundingTilesDictionary.keys)
        for index in 0..<surroundingTiles.count-1 {
            let randomIndex = Int(arc4random_uniform(UInt32((surroundingTiles.count) - index))) + index
            if index != randomIndex {
                swap(&surroundingTiles[index], &surroundingTiles[randomIndex])
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
