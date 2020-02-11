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

    var executionSequenceIteratorUT: ExecutionSequenceIterator!

    override func setUp() {
        super.setUp()
        self.executionSequenceIteratorUT = ExecutionSequenceIterator()
    }

    override func tearDown() {
        self.executionSequenceIteratorUT = nil
        super.tearDown()
    }

    func testExample() {

        setupSequenceIterator(5, skippedIndices: [3,4])

        executionSequenceIteratorUT.perform()

    }

}

// MARK: - Helpers
extension ExecutionSequencerTests {

    private func makeSequenceableObjects(_ count: UInt, skippedIndices: UInt...) -> [ObjectSequenceable] {
        makeSequenceableObjects(count, skippedIndices: skippedIndices)
    }

    private func makeSequenceableObjects(_ count: UInt, skippedIndices: [UInt] = []) -> [ObjectSequenceable] {
        let endIndex = count - 1
        var mutableSkippedInicesSet = Set(skippedIndices)
        var results = [ObjectSequenceable]()
        for index in 0...endIndex {
            let shouldSkip = mutableSkippedInicesSet.remove(index) != nil
            let objSeq = ObjectSequenceable("Object \(index)", shouldBypassSequence: shouldSkip)
            results.append(objSeq)
        }

        return results
    }

    private func setupSequenceIterator(_ count: UInt, skippedIndices: UInt...) {
        let objects = makeSequenceableObjects(count, skippedIndices: skippedIndices)
        fillIterator(with: objects)
    }

    private func setupSequenceIterator(_ count: UInt, skippedIndices: [UInt] = []) {
        let objects = makeSequenceableObjects(count, skippedIndices: skippedIndices)
        fillIterator(with: objects)
    }

    private func fillIterator(with objects: [ObjectSequenceable]) {
        for object in objects {
            executionSequenceIteratorUT.append { completionBlock in
                if object.shouldBypassSequence {
                    completionBlock()
                } else {
                    object.performSequenceAction(completionBlock)
                }
            }

        }
    }

}
