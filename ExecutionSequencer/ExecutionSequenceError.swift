//
//  ExecutionSequenceError.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/7/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

public enum ExecutionSequenceError: Error {
    case blockIsExecuting
    case blockHasAlreadyexecuted
    var localizedDescription: String {
        switch self {
        case .blockIsExecuting: return "Cannot append additional blocks to the sequence after calling execute()"
        case .blockHasAlreadyexecuted: return "This block has already been executed; please create another"
        }
    }
}
