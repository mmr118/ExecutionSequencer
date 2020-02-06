//
//  SomeAction.swift
//  ExecutionSequencerDemo
//
//  Created by Monica Rondón on 2/7/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import ExecutionSequencer
import UIKit

class SomeAction: NSObject, ExecutionSequenceable {
    
    var shouldBypassSequence: Bool
    private(set) var dismissCompletionBlock: ExecutionSequenceable.CompletionBlock?
    
    let itemNumber: Int
    var delay: TimeInterval
    var count = 0
    
    var controller: UIViewController?
    
    lazy var timer: Timer = {
        
        let timer = Timer(timeInterval: delay, repeats: false) { _ in
            self.count += 1
            print(self.count)
            self.sequenceAction()
        }
        
        RunLoop.current.add(timer, forMode: .common)
        return timer
        
    }()
    
    init(shouldBypass: Bool, delay: TimeInterval, num: Int) {
        self.shouldBypassSequence = shouldBypass
        self.delay = delay
        self.itemNumber = num
        super.init()
    }
    
    func performSequenceAction(_ block: @escaping ExecutionSequenceable.CompletionBlock) {
        
        self.dismissCompletionBlock = block
        
        self.timer.fire()
    }
    
    private func sequenceAction() {
        
        let alertController = UIAlertController(title: "Sequence Item \(itemNumber)", message: nil, preferredStyle: .alert)
        let dismissActoin = UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
            self.dismissCompletionBlock?()
        })
        
        alertController.addAction(dismissActoin)
        
        if let controller = controller {
            
            controller.present(alertController, animated: true)
            
        } else if let controller = UIApplication.shared.delegate?.window??.rootViewController {
            
            controller.present(alertController, animated: true)

        } else {
            
            print()
            
        }
        
    }
    
}
