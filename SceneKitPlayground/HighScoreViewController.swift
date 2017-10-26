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
    var highScoreDictionary = [Int: [ScoreObject]]()
    var activeArray = [ScoreObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        var highScoreArray = DataManager.sharedInstance.fetchScores()
        highScoreArray = highScoreArray.sorted { (struct1, struct2) -> Bool in
            if (struct1.steps != struct2.steps) {
                return struct1.steps < struct2.steps
            } else {
                return struct1.time < struct2.time
            }
        }
        
        for score in highScoreArray {
            let number = Int(score.mapNumber)
            if highScoreDictionary[number] == nil {
                highScoreDictionary.updateValue([ScoreObject](), forKey: number)
            }
            highScoreDictionary[number]?.append(score)
        }
        activeArray = highScoreDictionary[0] ?? [ScoreObject]()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreTableViewCell", for: indexPath) as! HighScoreTableViewCell
        let score = activeArray[indexPath.row]
        cell.stepsLabel.text = "Steps: \(score.steps)"
        let timeManager = TimeManager()
        timeManager.stopWatch.totalTime = Double(score.time)
        timeManager.updateStopWatch()
        cell.timeLabel.text = "Time: \(timeManager.getTimeString())"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @IBAction func segmentedControlToggled(_ sender: UISegmentedControl) {
        activeArray = highScoreDictionary[sender.selectedSegmentIndex] ?? [ScoreObject]()
        highScoreTableView.reloadData()
    }
}
