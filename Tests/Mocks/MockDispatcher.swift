//
//  MockDispatcher.swift
//  NetworkLayerTests
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation
@testable import NetworkLayer

public struct MockDispatcher: Dispatcher {
    let path: String
    let response: Data

    init(path: String, response: Data) {
        self.path = path
        self.response = response
    }

    public func dispatch(request: APIRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask{
        if request.path == path {
            completionHandler(.success(response))
        } else {
            completionHandler(.failure(DispatcherError.noData))
        }

        // For simplcitiy we use a URLSessionTask, we could abstract this as well with a TaskProtocol to avoid this warning
        return URLSessionTask()
    }

    public func cancel(request: APIRequest) {}
}
