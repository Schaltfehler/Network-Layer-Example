//
//  AsyncOperation.swift
//  NetworkLayer
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

public enum OperationError: Swift.Error {
    case canceled
    case noInput
    case noResult
}

public class AsyncOperation: Operation {

    public override init() {
    }

    override public var isAsynchronous: Bool {
        return true
    }

    private let stateQueue = DispatchQueue(label: "AsyncOperation.rw.state", attributes: .concurrent)

    private var _isExecuting: Bool = false
    override public var isExecuting: Bool {
        get {
            return stateQueue.sync {
                _isExecuting
            }
        }
        set {
            willChangeValue(forKey: #keyPath(isExecuting) )
            stateQueue.sync(flags: .barrier) {
                self._isExecuting = newValue
            }
            didChangeValue(forKey: #keyPath(isExecuting) )
        }
    }

    private var _isFinished: Bool = false
    override public var isFinished: Bool {
        get {
              return stateQueue.sync {
                _isFinished
              }
        }
        set {
            willChangeValue(forKey: #keyPath(isFinished) )
            stateQueue.sync(flags: .barrier) {
                self._isFinished = newValue
            }
            didChangeValue(forKey: #keyPath(isFinished) )
        }
    }

    // Start
    public final override func start() {
        if isCancelled {
            finish()
            return
        }

        isExecuting = true

        main()
    }

    open override func main() {
        assertionFailure("Override this method!")
    }

    public final func finish() {
        isExecuting = false
        isFinished = true
    }
}
