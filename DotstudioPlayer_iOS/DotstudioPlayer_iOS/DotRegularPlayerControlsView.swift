//
//  DotRegularPlayerControlsView.swift
//  DotstudioPlayer_iOS
//
//  Created by Ketan Sakariya on 13/03/18.
//  Copyright © 2018 Ketan Sakariya. All rights reserved.
//

import Foundation

protocol DotRegularPlayerControlsViewDelegate: DotPlayerControlsViewDelegate {
    //    func didTriggerActionForExpandButton(_ sender: Any)
}

class DotRegularPlayerControlsView: DotPlayerControlsView {
    
    public override func play() {
        self.buttonPlay?.isSelected = true
        self.buttonBigPlay?.isSelected = true
    }
    
    public override func pause() {
        self.buttonPlay?.isSelected = false
        self.buttonBigPlay?.isSelected = false
    }

}



