//
//  OptionsTableViewController.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-22.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class OptionsTableViewController: UITableViewController {
    
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var tagTextField: UITextField!
    
    let tagTableViewDataSource = TagTableViewDataSource()
    let mazeManager = MazeManager.sharedInstance
    
    @IBOutlet weak var curatedListSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        tagTableViewDataSource.setUp()
        tagTableView.dataSource = tagTableViewDataSource
        tagTableViewDataSource.tableView = tagTableView
        curatedListSwitch.isOn = mazeManager.options.easyMode
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func addTagPressed(_ sender: UIButton) {
        tagTableViewDataSource.addTag(tagTextField.text ?? "")
        tagTextField.text = ""
    }
    
    @IBAction func curatedListSwitchToggled(_ sender: UISwitch) {
        tableView.beginUpdates()
        tagTableViewDataSource.tagHeight = CGFloat(mazeManager.options.tagArray.count * 44)
        if sender.isOn {
            tagTableViewDataSource.tagHeight = 0
        }
        tableView.endUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let mazeManager = MazeManager.sharedInstance
        tagTableViewDataSource.updateTagArray()
        mazeManager.options.easyMode = curatedListSwitch.isOn
        super.viewWillDisappear(animated)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}
