//
//  ExecutionSequenceIterator.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/6/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

@objc public class ExecutionSequenceIterator: NSObject {

    @objc public internal(set) var state: SequenceState {
        didSet { state = (oldValue == .didExecute) ? oldValue : state }
    }

    internal var sequenceBlocks: [ExecutionSequenceable.SequenceBlock] = []

    @objc public override init() {
        self.state = .empty
        super.init()
    }

}


// MARK: - Public
public extension ExecutionSequenceIterator {
    
    @objc func append(_ block: @escaping ExecutionSequenceable.SequenceBlock) {
        guard canUpdateSequenceBlock() else { errorHandler(.blockIsExecuting); return }
        
        displayDebugMessage("Adding block to sequence")

        if state == .empty {
            state = .ready
        }

        sequenceBlocks.append(block)
    }

    @discardableResult
    @objc func removeBlock(at index: Int) -> ExecutionSequenceable.SequenceBlock? {
        guard canUpdateSequenceBlock() else { return nil }
        guard sequenceBlocks.indices.contains(index) else { return nil }
        
        displayDebugMessage("Removing block at index: \(index)")
        
        let removedBlock = sequenceBlocks.remove(at: index)

        if sequenceBlocks.isEmpty {
            state = .empty
        }

        return removedBlock
    }
    
    @discardableResult
    @objc func removeLastBlock() -> ExecutionSequenceable.SequenceBlock? {
        guard canUpdateSequenceBlock() else { return nil }
        guard sequenceBlocks.last != nil else { return nil }

        displayDebugMessage("Removing last block")
        
        let removedBlock = sequenceBlocks.removeLast()

        if sequenceBlocks.isEmpty {
            state = .empty
        }

        return removedBlock
    }
    
    @discardableResult
    @objc func removeFirstBlock() -> ExecutionSequenceable.SequenceBlock? {
        guard canUpdateSequenceBlock() else { return nil }
        guard sequenceBlocks.first != nil else { return nil }

        displayDebugMessage("Removing first block")
        
        let removedBlock = sequenceBlocks.removeFirst()

        if sequenceBlocks.isEmpty {
            state = .empty
        }

        return removedBlock
    }
    
    @discardableResult
    func removeAllBlocks() -> [ExecutionSequenceable.SequenceBlock] {
        guard canUpdateSequenceBlock() else { return [] }
        let currentBlocks = sequenceBlocks

        state = .empty

        sequenceBlocks.removeAll()

        return currentBlocks
    }

    @objc func execute() {

        if state == .ready {
            displayDebugMessage("Executing Sequences")
            state = .isExecuting
            performBlock(at: 0)
        }
        
    }

}


// MARK: - Internal
internal extension ExecutionSequenceIterator {
    
    func canUpdateSequenceBlock() -> Bool {
        switch state {
        case .ready, .empty:
            return true

        case .isExecuting:
            errorHandler(.blockIsExecuting)
            return false

        case .didExecute:
            errorHandler(.blockHasAlreadyexecuted)
            return false
        }
    }

}

// MARK: - Private
private extension ExecutionSequenceIterator {

    func performBlock(at index: Int) {

        let aBlock = sequenceBlocks[index]

        // Perform the block, passing in a completion block that will execute the next block in the operation sequence
        displayDebugMessage("Will execute sequence block at \(index)")

        aBlock {

            self.displayDebugMessage("Block at \(index) executed; completion function")

            let nextIndex = index + 1

            if nextIndex < self.sequenceBlocks.count {

                self.performBlock(at: nextIndex)

            } else {

                self.displayDebugMessage("ExecutionSequence Complete")

                self.state = .didExecute

            }

        }
    }
    
}
