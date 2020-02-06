//
//  ExecutionSequencerTests.swift
//  ExecutionSequencerTests
//
//  Created by Monica Rondón on 2/6/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import XCTest
@testable import ExecutionSequencer

class ExecutionSequencerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

// EXAMPLE

class FooAction: NSObject, ExecutionSequenceProtocol {

    var dismissCompletionBlock: ESCompletionBlock?

    var firstPass = false

    let message: String
    var shouldBypassSequence: Bool

    init(_ message: String, shouldBypassSequence: Bool = false) {
        self.message = message
        self.shouldBypassSequence = shouldBypassSequence
        super.init()
    }

    func performSequenceAction(_ block: @escaping ESCompletionBlock) {
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


class FooClass {

    func foo() {


        let excSeq = ExecutionSequenceIterator()

        let action1 = FooAction("action1")
        let action2 = FooAction("action2", shouldBypassSequence: true)
        let action3 = FooAction("action3")
        let action4 = FooAction("action4")


        let block: ESBlock = { _ in }

        excSeq.append(block)


        excSeq.append { (completionBlock) in

            let action = action1

            if action.shouldBypassSequence {
                print("shouldBypassSequence - \(action.message)")
                completionBlock()
            } else {
                action.performSequenceAction(completionBlock)

            }

        }

        excSeq.append { (completionBlock) in

            let action = action2

            if action.shouldBypassSequence {
                print("shouldBypassSequence - \(action.message)")
                completionBlock()
            } else {
                action.performSequenceAction(completionBlock)

            }

        }

        excSeq.append { (completionBlock) in

            let action = action3

            if action.shouldBypassSequence {
                print("shouldBypassSequence - \(action.message)")
                completionBlock()
            } else {
                action.performSequenceAction(completionBlock)

            }

        }

        excSeq.append { (completionBlock) in

            let action = action4

            if action.shouldBypassSequence {
                print("shouldBypassSequence - \(action.message)")
                completionBlock()
            } else {
                action.performSequenceAction(completionBlock)

            }

        }

        excSeq.perform()

    }

}
