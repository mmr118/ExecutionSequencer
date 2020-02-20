//
//  ObjectSequenceable.swift
//  ExecutionSequencerDemo
//
//  Created by Monica Rondón on 2/7/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import ExecutionSequencer
import UIKit

class ObjectSequenceable: NSObject, ExecutionSequenceable {

    var shouldBypass: Bool
    var handoffBlock: HandoffBlock?
    
    let index: Int
    let delay: TimeInterval
    let controller: UIViewController
    
    lazy var timer: Timer = {
        let timer = Timer(timeInterval: delay, repeats: false) { _ in self.sequenceAction() }
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
    
    init(shouldBypass: Bool, delay: TimeInterval = 2, index: Int, controller: UIViewController) {
        self.shouldBypass = shouldBypass
        self.delay = delay
        self.index = index
        self.controller = controller
        super.init()
    }
    
    func executeSequenceAction(_ handoffBlock: @escaping HandoffBlock) {
        self.handoffBlock = handoffBlock
        self.timer.fire()
    }

    func executeSequenceActionIfNeeded(_ handoffBlock: @escaping HandoffBlock) {
        if self.shouldBypass {
            handoffBlock()
        } else {
            self.handoffBlock = handoffBlock
            self.timer.fire()
        }
    }
    
    private func sequenceAction() {
        let alertController = UIAlertController(title: "Sequence Item \(index)", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
            self.handoffBlockIfNeeded()
            self.controller.dismiss(animated: true)
        }))

        controller.present(alertController, animated: true)
    }
    
}
