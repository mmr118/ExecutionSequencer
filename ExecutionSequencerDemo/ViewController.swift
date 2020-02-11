//
//  ViewController.swift
//  ExecutionSequencerDemo
//
//  Created by Monica Rondón on 2/7/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import UIKit
import ExecutionSequencer

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!

    var sequenceIterator: ExecutionSequenceIterator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSequence()
        
    }
    
    func setupSequence() {
        
        let iterator = ExecutionSequenceIterator()
        
        for index in 0...5 {
            
            let someAction = ObjectSequenceable(shouldBypass: false, delay: 2, num: index)
            someAction.controller = self
            
            iterator.append { completionBlock in
                
                print("Performing block at \(index)")
                
                if someAction.shouldBypassSequence {
                    completionBlock()
                } else {
                    someAction.performSequenceAction(completionBlock)
                }
            }
        }
        
        iterator.append { completionBlock in
            self.button.setTitle("Reset", for: UIControl.State())
            self.sequenceIterator = nil
            completionBlock()
        }
        
        self.sequenceIterator = iterator
        
    }
    

    @IBAction func performSequence() {
        if let iterator = sequenceIterator {
            
            switch iterator.state {
            case .isPerforming, .didPerform: return
            case .empty, .ready:
                print(iterator.count)
                iterator.perform()
            }

        } else {
            setupSequence()
            button.setTitle("Perform", for: UIControl.State())
        }
        
    }

}
