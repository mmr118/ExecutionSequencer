//
//  TODO.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/7/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

// TODO: - Finish Error handling

extension ExecutionSequenceIterator {
    
    
    private func _performBlock(at index: Int) {

//        let aBlock = sequenceBlocks.remove(at: index) // sequenceBlocks[index]
        
        // .....
        // Remove blocks from seuencesBlocks and always pop first?

    }
    
    private func append_Err(_ block: @escaping ExecutionSequenceable.SequenceBlock) throws {
        guard canUpdateSequenceBlock() else { throw errorHandler(.blockIsExecuting) }
        
        displayDebugMessage("Adding block to sequence")

        if state == .empty {
            state = .ready
        }

        sequenceBlocks.append(block)
    }
    
    @discardableResult
    private func removeBlock_Err(at index: Int) throws -> ExecutionSequenceable.SequenceBlock? {
        guard canUpdateSequenceBlock() else { throw errorHandler(.blockIsExecuting) }
        guard sequenceBlocks.indices.contains(index) else { return nil }
        let removedBlock = sequenceBlocks.remove(at: index)
        if sequenceBlocks.isEmpty {
            state = .empty
        }
        return removedBlock
    }
    
    @discardableResult
    private func removeLastBlock_Err() throws -> ExecutionSequenceable.SequenceBlock? {
        guard canUpdateSequenceBlock() else { throw errorHandler(.blockIsExecuting) }
        let removedBlock = sequenceBlocks.removeLast()
        if sequenceBlocks.isEmpty {
            state = .empty
        }
        return removedBlock
    }
    
    @discardableResult
    private func removeFirstBlock_Err() throws -> ExecutionSequenceable.SequenceBlock? {
        guard canUpdateSequenceBlock() else { throw errorHandler(.blockIsExecuting) }
        let removedBlock = sequenceBlocks.removeFirst()
        if sequenceBlocks.isEmpty {
            state = .empty
        }
        return removedBlock
    }
    
    @discardableResult
    private func removeAllBlocks_Err() throws -> [ExecutionSequenceable.SequenceBlock] {
        guard canUpdateSequenceBlock() else { throw errorHandler(.blockIsExecuting) }
        let currentBlocks = sequenceBlocks
        state = .empty
        sequenceBlocks.removeAll()
        return currentBlocks
    }

}
