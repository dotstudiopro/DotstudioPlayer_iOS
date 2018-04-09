//
//  DotLivePlayerControlsView.swift
//  DotstudioPlayer_iOS
//
//  Created by Ketan Sakariya on 13/03/18.
//  Copyright © 2018 Ketan Sakariya. All rights reserved.
//

import Foundation

protocol DotLivePlayerControlsViewDelegate: DotPlayerControlsViewDelegate {
//    func didTriggerActionForExpandButton(_ sender: Any)
}

class DotLivePlayerControlsView: DotPlayerControlsView {
    var delegate: DotLivePlayerControlsViewDelegate?

    override var useTopBarControls: Bool {
        didSet {
            if useTopBarControls {
                self.viewTopBar?.isHidden = false
            } else {
                self.viewTopBar?.isHidden = true
            }
        }
    }
    override var useBottomBarControls: Bool {
        didSet {
            if useBottomBarControls {
                self.viewBottomBar?.isHidden = false
            } else {
                self.viewBottomBar?.isHidden = true
            }
        }
    }
    public override func play() {
        self.buttonPlay?.isSelected = true
        self.buttonBigPlay?.isSelected = true
    }
    
    public override func pause() {
        self.buttonPlay?.isSelected = false
        self.buttonBigPlay?.isSelected = false
    }
    @IBAction func didTriggerActionForBigPlayButton(_ sender: Any) {
        print("Big play Button Action Triggered.")
        self.delegate?.didTriggerActionForPlayButton(self)
    }
    @IBAction override func didTriggerActionForPlayButton(_ sender: Any) {
        print("Play Button Action Triggered.")
        self.delegate?.didTriggerActionForPlayButton(self)
    }
    @IBAction override func didTriggerActionForExpandButton(_ sender: Any) {
        print("Expand Button Action Triggered.")
        self.delegate?.didTriggerActionForExpandButton(self)
    }
    @IBAction override func didTriggerActionForCastButton(_ sender: Any) {
        self.delegate?.didTriggerActionForCastButton(self)
    }
    @IBAction override func didTriggerActionForShareButton(_ sender: Any) {
        self.delegate?.didTriggerActionForShareButton(self)
    }

}







