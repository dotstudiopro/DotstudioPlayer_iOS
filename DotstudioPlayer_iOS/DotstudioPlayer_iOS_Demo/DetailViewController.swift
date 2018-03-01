//
//  DetailViewController.swift
//  DotstudioPlayer_iOS_Demo
//
//  Created by Ketan Sakariya on 01/03/18.
//  Copyright © 2018 Ketan Sakariya. All rights reserved.
//

import UIKit
import DotstudioPlayer_iOS

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var dotPlayerView: DotPlayerView!
    
    func configureView() {
        // Update the user interface for the detail item.
//        if let detail = detailItem {
//            if let label = detailDescriptionLabel {
//                label.text = detail.description
//            }
//        }
        
//        let dotPlayerView = DotPlayerView(frame: self.viewPlayer.bounds)
//        dotPlayerView.set(strVideoUrl: "vid url")
//        self.viewPlayer.addSubview(dotPlayerView)
//        self.viewPlayer.bringSubview(toFront: dotPlayerView)
//        dotPlayerView.play()
        self.dotPlayerView.set(strVideoUrl: "vid url")
        self.dotPlayerView.play()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

