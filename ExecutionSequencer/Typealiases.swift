//
//  Typealiases.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/6/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

public extension ExecutionSequenceable {
    
    typealias CompletionBlock = () -> Void
    typealias Block = (@escaping CompletionBlock) -> Void
    
}

public extension ExecutionSequenceIterator {
    
    typealias DebugStrategyHandler = (Any) -> Void

}
