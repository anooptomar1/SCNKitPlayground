//
//  HighScoreViewController.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-25.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var highScoreTableView: UITableView!
    var highScoreArray = [ScoreObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        highScoreArray = DataManager.sharedInstance.fetchScores()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreTableViewCell", for: indexPath) as! HighScoreTableViewCell
        let score = highScoreArray[indexPath.row]
        cell.stepsLabel.text = "Steps: \(score.steps)"
        let timeManager = TimeManager()
        timeManager.stopWatch.totalTime = Double(score.time)
        timeManager.updateStopWatch()
        cell.timeLabel.text = timeManager.getTimeString()
        
        return cell
    }
    
}
