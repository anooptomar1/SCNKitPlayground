//
//  Protocols.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-17.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import Foundation

protocol NetworkViewControllerProtocol {
    func callSucceeded()
    func callFailed(message: String)
    func updateProgress()
}

protocol EndGameProtocol {
    func endGame()
}
