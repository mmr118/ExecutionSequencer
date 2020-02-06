//
//  ExecutionSequenceIterator.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/6/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

public class ExecutionSequenceIterator: NSObject {
        
    public var count: UInt { return UInt(sequenceBlocks.count) }
    
    public internal(set) var state: SequenceState
    
    internal var sequenceBlocks: [ExecutionSequenceable.Block] = []

    public override init() {
        self.state = .empty
        super.init()
    }
    
    public func append(_ block: @escaping ExecutionSequenceable.Block) {
        guard canUpdateSequenceBlock() else { errorHandler(.blockIsPerforming); return }
        
        displayDebugMessage("Adding block to sequence")

        if state == .empty {
            state = .ready
        }
        sequenceBlocks.append(block)
    }
    
    @discardableResult
    public func removeBlock(at index: Int) -> ExecutionSequenceable.Block? {
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
    public func removeLastBlock() -> ExecutionSequenceable.Block? {
        guard canUpdateSequenceBlock() else { return nil }
        
        displayDebugMessage("Removing last block")
        
        let removedBlock = sequenceBlocks.removeLast()
        if sequenceBlocks.isEmpty {
            state = .empty
        }
        return removedBlock
    }
    
    @discardableResult
    public func removeFirstBlock() -> ExecutionSequenceable.Block? {
        guard canUpdateSequenceBlock() else { return nil }
        
        displayDebugMessage("Removing first block")
        
        let removedBlock = sequenceBlocks.removeFirst()
        if sequenceBlocks.isEmpty {
            state = .empty
        }
        return removedBlock
    }
    
    @discardableResult
    public func removeAllBlocks() -> [ExecutionSequenceable.Block] {
        guard canUpdateSequenceBlock() else { return [] }
        let currentBlocks = sequenceBlocks
        state = .empty
        sequenceBlocks.removeAll()
        return currentBlocks
    }

    
        
    public func perform() {
        
        guard state == .ready else { return }

        displayDebugMessage("Performing Sequences")

        state = .isPerforming
        performBlock(at: 0)
        
    }
    
}

// MARK: - Private
extension ExecutionSequenceIterator {
    
    internal func canUpdateSequenceBlock() -> Bool {
        switch state {
        case .ready, .empty: return true
        case .isPerforming:
            errorHandler(.blockIsPerforming)
            return false
        case .didPerform:
            errorHandler(.blockHasAlreadyPerformed)
            return false
        }
    }
    
    private func performBlock(at index: Int) {

        let aBlock = sequenceBlocks[index]

        // Perform the block, passing in a completion block that will execute the next block in the operation sequence
        displayDebugMessage("Will execute sequence block at \(index)")

        aBlock {

            self.displayDebugMessage("Block at \(index) executed completion function")

            let nextIndex = index + 1

            if nextIndex < self.sequenceBlocks.count {

                self.performBlock(at: nextIndex)

            } else {

                self.displayDebugMessage("ExecutionSequence Complete")

                self.state = .didPerform

            }
        }
    }
    
}
