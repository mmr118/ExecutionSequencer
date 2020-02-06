//
//  ExecutionSequenceIterator+DebugOutputStrategy.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/6/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

extension ExecutionSequenceIterator {
    
    public private(set) static var debugOutputStrategy: DebugOutputStrategy = .none
    
    private var debugOutputHandler: DebugStrategyHandler? { return ExecutionSequenceIterator.debugOutputStrategy.handler }

    public enum DebugOutputStrategy {
        case none
        case print
        case other(DebugStrategyHandler)

        public var handler: DebugStrategyHandler? {
            switch self {
            case .none: return nil
            case .print: return { Swift.print($0) }
            case .other(let handler): return { handler($0) }
            }
        }

    }
    
    public static func setDebugStrategy(_ strategy: DebugOutputStrategy) {
        debugOutputStrategy = strategy
    }
    
    public func setDebugStrategy(_ strategy: DebugOutputStrategy) {
        ExecutionSequenceIterator.setDebugStrategy(strategy)
    }
    
    @discardableResult
    internal func errorHandler(_ error: ExecutionSequenceError) -> Error {
        displayDebugMessage(error.localizedDescription)
        assertionFailure()
        return error
    }
    
    @discardableResult
    internal func errorHandler(_ error: Error) -> Error {
        displayDebugMessage(error.localizedDescription)
        assertionFailure()
        return error
    }
        
    internal func displayDebugMessage(_ item: Any) {

        DispatchQueue.main.async {
            self.debugOutputHandler?(item)
        }

    }

}
