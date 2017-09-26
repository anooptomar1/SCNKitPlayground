//
//  EndGameViewController.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-25.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var player: PlayerObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepLabel.text = "Steps: \(player.steps)"
        
        let timeManager = TimeManager()
        timeManager.stopWatch.totalTime = Double(player.time)
        timeManager.updateStopWatch()
        timeLabel.text = timeManager.getTimeString()
        let score = DataManager.sharedInstance.generateScore()
        score.time = player.time
        score.steps = player.steps
        DataManager.sharedInstance.saveContext()
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
}
