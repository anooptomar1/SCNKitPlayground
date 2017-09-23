//
//  TagTableViewDataSource.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-22.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class TagTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var tagSet = Set<String>()
    var tagArray = [String]()
    var tableView: UITableView!
    var cellArray = [TagTableViewCell]()
    var tagHeight: CGFloat = 150
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagTableViewCell", for: indexPath) as! TagTableViewCell
        let tag = tagArray[indexPath.row]
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
    
    func addTag(_ tag: String) {
        if tag == "" {
            return
        }

        if !tagSet.contains(tag) {
            tagSet.insert(tag)
            tagArray = Array(tagSet)
            tagArray = tagArray.sorted {
                $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending
            }
            let index = tagArray.index(of: tag) ?? 0
            let indexPath = IndexPath(item: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func getTagArray() -> [String] {
        var tags = [String]()
        for cell in cellArray {
            if cell.onSwitch.isOn {
                tags.append(cell.nameLabel.text ?? "")
            }
        }
        return tags
    }    
}
