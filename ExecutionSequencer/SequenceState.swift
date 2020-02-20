//
//  SequenceState.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/6/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

@objc public enum SequenceState: Int, CaseIterable {
    case empty
    case ready
    case isExecuting
    case didExecute

    public var stringValue: String {
        switch self {
        case .empty: return "empty"
        case .ready: return "ready"
        case .isExecuting: return "isPerforming"
        case .didExecute: return "didPerform"
        }
    }
}
