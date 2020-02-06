//
//  ExecutionSequenceable.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/6/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

public protocol ExecutionSequenceable: NSObjectProtocol {
    
    var shouldBypassSequence: Bool { get }
    var dismissCompletionBlock: CompletionBlock? { get }
    func performSequenceAction(_ block: @escaping CompletionBlock)
    
}
