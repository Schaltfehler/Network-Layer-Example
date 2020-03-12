//
//  Client.swift
//  NetworkLayer
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

public struct Client {

    private let dispatcher: Dispatcher
    private let decoder = JSONDecoder()

    public init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }

    @discardableResult
    func execute<ResponseType: Codable> (request: APIRequest,
                                         completionHandler: @escaping (Result<ResponseType, Error>) -> Void)
        -> URLSessionTask {
        dispatcher.dispatch(request: request) { (result: Result<Data, Error>) in
            let decodedResult = result.flatMap { data in
                Result { try self.decoder.decode(ResponseType.self, from: data) }
            }
            completionHandler(decodedResult)
        }
    }
}
