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
    var tableView: UITableView!
    var tagHeight: CGFloat = 150
    var tagSet = Set<String>()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mazeManager.options.tagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagTableViewCell", for: indexPath) as! TagTableViewCell
        let tag = mazeManager.options.tagArray[indexPath.row]
        cell.tagObject = tag
        cell.onSwitch.isOn = tag.isOn
        cell.nameLabel.text = tag.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return tagHeight
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tag = mazeManager.options.tagArray[indexPath.row]
            mazeManager.options.tagArray.remove(at: indexPath.row)
            DataManager.sharedInstance.persistentContainer.viewContext.delete(tag)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func setUp() {
        for tag in mazeManager.options.tagArray {
            tagSet.insert(tag.name!)
        }
    }
    
    func addTag(_ tag: String) {
        if tag == "" {
            return
        }
        
        if !tagSet.contains(tag) {
            tagSet.insert(tag)
            let newTag = DataManager.sharedInstance.generateTag()
            newTag.name = tag
            mazeManager.options.tagArray.append(newTag)
            mazeManager.options.tagArray = mazeManager.options.tagArray.sorted {
                $0.name!.localizedCaseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending
            }
            
            let index = mazeManager.options.tagArray.index(of: newTag) ?? 0
            let indexPath = IndexPath(item: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}
