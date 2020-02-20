//
//  ExecutionSequenceable.swift
//  ExecutionSequencer
//
//  Created by Monica Rondón on 2/6/20.
//  Copyright © 2020 Monica Rondón. All rights reserved.
//

import Foundation

@objc public protocol ExecutionSequenceable: NSObjectProtocol {

    @objc optional var name: String { get }

    @objc var shouldBypass: Bool { get }
    @objc var handoffBlock: HandoffBlock? { get set }

    @objc func executeSequenceAction(_ handoffBlock: @escaping HandoffBlock)

}

public extension ExecutionSequenceable {

    func handoffBlockIfNeeded() {
        if self.handoffBlock != nil {
            self.handoffBlock?()
            self.handoffBlock = nil
        }
    }
}
