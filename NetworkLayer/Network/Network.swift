//
//  Network.swift
//  NetworkLayer
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

public protocol Dispatcher {
    func dispatch(request: APIRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask
}

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
}

public struct APIRequest {
    let method: HTTPMethod
    let path: String

    let queryParameter: [URLQueryItem]?
    let headers: [String: String]?
    let body: Data?

    init (
        method: HTTPMethod,
        path: String,
        queryParameter: [URLQueryItem]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil
        ) {
        self.path = path
        self.method = method
        self.queryParameter = queryParameter
        self.headers = headers
        self.body = body
    }
}
