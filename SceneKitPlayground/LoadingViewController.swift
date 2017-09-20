//
//  LoadingViewController.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-17.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, NetworkViewControllerProtocol {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        activityIndicator.startAnimating()
        let mazeManager = MazeManager.sharedInstance
        mazeManager.delegate = self
        mazeManager.setUp()
        progressView.progress = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callSucceeded() {
        performSegue(withIdentifier: "GameViewController", sender: nil)
    }
    
    func callFailed() {
        
    }
    
    func updateProgress() {
            progressView.progress += 0.01
        print(progressView.progress)
    }
}
