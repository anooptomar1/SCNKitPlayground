//
//  TagTableViewDataSource.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-22.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class TagTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let mazeManager = MazeManager.sharedInstance
    var sortedTagArray = [String]()
    var tableView: UITableView!
    var cellArray = [TagTableViewCell]()
    var tagHeight: CGFloat = 150
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagTableViewCell", for: indexPath) as! TagTableViewCell
        let tag = sortedTagArray[indexPath.row]
        cell.nameLabel.text = tag
        cellArray.append(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return tagHeight
        }
        return 44
    }
    
    func setUp() {
        let tagArray = Array(mazeManager.options.tags.keys)
        sortedTagArray = tagArray.sorted {
            $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending
        }
    }
    
    func addTag(_ tag: String) {
        if tag == "" {
            return
        }

        if !mazeManager.options.tags.keys.contains(tag) {
            mazeManager.options.tags.updateValue(true, forKey: tag)
            sortedTagArray = Array(mazeManager.options.tags.keys)
            sortedTagArray = sortedTagArray.sorted {
                $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending
            }
            let index = sortedTagArray.index(of: tag) ?? 0
            let indexPath = IndexPath(item: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func getTagArray() -> [String: Bool] {
        var tags = [String: Bool]()
        for cell in cellArray {
            let isOn = cell.onSwitch.isOn
            tags.updateValue(isOn, forKey: cell.nameLabel.text ?? "No name")
        }
        return tags
    }    
}
