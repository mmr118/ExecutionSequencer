//
//  ExecutionSequenceError.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/7/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

public enum ExecutionSequenceError: Error {
    case blockIsPerforming
    case blockHasAlreadyPerformed
    var localizedDescription: String {
        switch self {
        case .blockIsPerforming: return "Cannot append additional blocks to the sequence after calling perform()"
        case .blockHasAlreadyPerformed: return "This block has already been executed; please create another"
        }
    }
}
