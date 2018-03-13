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

    @IBAction override func didTriggerActionForPlayButton(_ sender: Any) {
        self.delegate?.didTriggerActionForPlayButton(self)
    }
    @IBAction override func didTriggerActionForExpandButton(_ sender: Any) {
        print("Expand Button Action Triggered.")
        self.delegate?.didTriggerActionForExpandButton(self)
    }

}







