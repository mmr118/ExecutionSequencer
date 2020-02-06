//
//  SequenceState.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/6/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

public enum SequenceState: String {
    case empty
    case ready
    case isPerforming
    case didPerform
}
