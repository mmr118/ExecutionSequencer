//
//  Typealiases.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/6/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

public extension ExecutionSequenceable {
    typealias HandoffBlock = () -> Void
    typealias SequenceBlock = (@escaping HandoffBlock) -> Void
}

public extension ExecutionSequenceIterator {
    typealias DebugStrategyHandler = (Any) -> Void
}
