//
//  Maze.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-05.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class Maze: NSObject {
    var start = (0, 0)
    var end = (0, 0)
    var invalid = [Int: [Int]]()
    var startFacing:Direction = .north
    
    init(dictionary: [Int: [Int]]) {
        invalid = dictionary
        super.init()
    }
    
    
}
