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
        var strUrl = "https://k7q5a5e5.ssl.hwcdn.net/files/company/53fd1266d66da833047b23c6/assets/videos/540f28fdd66da89e1ed70281/vod/540f28fdd66da89e1ed70281.m3u8"
        strUrl = "https://vcndecentric.teleosmedia.com/stream/decentric/dclive1/playlist.m3u8"
        
        
        let dotPlayerObject = DotPlayerObject()
        dotPlayerObject.strVideoUrl = strUrl
        dotPlayerObject.isLiveStreaming = true
        self.dotPlayerView.setPlayerObject(dotPlayerObject)
        self.dotPlayerView.delegate = self
        
        
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
//        label.text = "Test text"
//        label.textColor = UIColor.red
//        self.dotPlayerView.viewContentOverlayPlayerController?.addSubview(label)
//        self.dotPlayerView.viewContentOverlayPlayerController?.bringSubview(toFront: label)
//        self.labelTest = label
    }
//    var labelTest: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dotPlayerView.play()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        if let labelTest = self.labelTest {
//            self.dotPlayerView.viewContentOverlayPlayerController?.bringSubview(toFront: labelTest)
//        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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


extension DetailViewController: DotPlayerViewDelegate {
    func didPlayerBecomeReady(_ dotPlayerObject: DotPlayerObject) {
        
    }
    func didFailedToLoadPlayer(_ dotPlayerObject: DotPlayerObject) {
        
    }
    func didPlayDotPlayerVideo(_ dotPlayerObject: DotPlayerObject) {
        
    }
    func didPauseDotPlayerVideo(_ dotPlayerObject: DotPlayerObject) {
        
    }
    //    func didResumeDotPlayerVideo(_ dotPlayerObject: DotPlayerObject)
    func didEndPlaybackDotPlayerVideo(_ dotPlayerObject: DotPlayerObject) {
        
    }

    func didTriggerActionForCastButton(_ dotPlayerObject: DotPlayerObject) {
        
    }
    func didTriggerActionForShareButton(_ dotPlayerObject: DotPlayerObject) {
        
    }
    
}


