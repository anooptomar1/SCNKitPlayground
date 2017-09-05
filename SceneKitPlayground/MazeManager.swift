//
//  MazeManager.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-05.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class MazeManager: NSObject {
    static let sharedInstance = MazeManager()
    private override init() {}
    var maze = Maze(dictionary: [:])
    func setUp() {
        maze = Maze(dictionary: [
        1: [1, 2, 4, 6, 7, 9],
        2: [1, 7, 9],
        3: [3, 5, 9],
        4: [1, 5, 7, 9],
        5: [3, 4, 5, 7, 9],
        6: [1, 9],
        7: [1, 2, 4, 5, 7, 9],
        9: [0, 1, 2, 3, 4, 5, 6, 7]
        ])
        maze.start = (9, 9)
        maze.end = (4, 4)
    }
}
