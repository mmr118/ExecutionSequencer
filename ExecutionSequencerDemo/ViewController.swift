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
    @IBOutlet weak var altButton: UIButton!
    @IBOutlet weak var sequenceStack: UIStackView!

    var sequenceIterator: ExecutionSequenceIterator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSequence()
    }

    @IBAction func performSequence(_ sender: UIButton?) {

        if let iterator = sequenceIterator {

            switch iterator.state {

            case .empty, .ready:
                print(#function)
                iterator.execute()

            case .isExecuting, .didExecute:
                return
            }

        } else {
            setupSequence()
            button.setTitle("Perform", for: UIControl.State())
        }

    }

    func setupSequence() {
        
        let iterator = ExecutionSequenceIterator()

        for index in 1...8 {

            let object = ObjectSequenceable(shouldBypass: Bool.random(), index: index, controller: self)


            iterator.append { handoffBlock in

                print("Performing block at \(object.index)")

                if object.shouldBypass {
                    handoffBlock()
                } else {
                    object.executeSequenceAction(handoffBlock)
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

}
