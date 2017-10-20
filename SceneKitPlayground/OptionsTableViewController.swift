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
    }
    
    @IBAction func easyModeSwitchToggled(_ sender: UISwitch) {
        mazeManager.options.easyMode = sender.isOn
    }
    
    @IBAction func addTagPressed(_ sender: UIButton) {
        tagTableViewDataSource.addTag(tagTextField.text ?? "")
        tagTextField.text = ""
        tagTextField.resignFirstResponder()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        DataManager.sharedInstance.saveContext()
        super.viewWillDisappear(animated)
    }
}
