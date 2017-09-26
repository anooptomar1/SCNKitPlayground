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
    
    @IBOutlet weak var easyModeSwitch: UISwitch!
    let tagTableViewDataSource = TagTableViewDataSource()
    let mazeManager = MazeManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagTableViewDataSource.setUp()
        tagTableView.dataSource = tagTableViewDataSource
        tagTableViewDataSource.tableView = tagTableView
        easyModeSwitch.isOn = mazeManager.options.easyMode
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func easyModeSwitchToggled(_ sender: UISwitch) {
        mazeManager.options.easyMode = sender.isOn
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
        DataManager.sharedInstance.saveContext()
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
