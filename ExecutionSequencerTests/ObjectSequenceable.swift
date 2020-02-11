//
//  ObjectSequenceable.swift
//  ExecutionSequencerTests
//
//  Created by Rondon Monica on 11.02.20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation
import ExecutionSequencer

class ObjectSequenceable: NSObject, ExecutionSequenceable {

    var dismissCompletionBlock: CompletionBlock?

    var firstPass = false

    let message: String
    var shouldBypassSequence: Bool

    init(_ message: String, shouldBypassSequence: Bool = false) {
        self.message = message
        self.shouldBypassSequence = shouldBypassSequence
        super.init()
    }

    func performSequenceAction(_ block: @escaping CompletionBlock) {
        dismissCompletionBlock = block
        sequenceAction()
    }

    private func sequenceAction() {

        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in

            if self.firstPass == false {
                self.firstPass = true
            } else {
                timer.invalidate()
                print(">> " + self.message)
                self.dismissCompletionBlock?()
            }
        }

        timer.fire()

    }

}
