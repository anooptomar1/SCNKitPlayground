//
//  LoadingViewController.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-17.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, NetworkViewControllerProtocol {

    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        activityIndicator.isHidden = true
        
        progressView.progress = 0
        progressView.isHidden = true
        
        MazeManager.sharedInstance.getPersistentData()
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        progressView.isHidden = false
        
        buttonView.isUserInteractionEnabled = false
        buttonView.alpha = 0.5
        
        let mazeManager = MazeManager.sharedInstance
        mazeManager.delegate = self
        mazeManager.setUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callSucceeded() {
        performSegue(withIdentifier: "GameViewController", sender: nil)
        resetView()
    }
    
    func callFailed(message: String) {
        let alertController = UIAlertController(title: "Cannot Continue", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        resetView()
    }
    
    func resetView() {
        buttonView.isUserInteractionEnabled = true
        buttonView.alpha = 1
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        progressView.progress = 0
        progressView.isHidden = true
    }
    
    //This is called in the maze manager when a tile is created from the NetworkViewControllerProtocol
    func updateProgress() {
        progressView.progress += 0.01
    }
}
