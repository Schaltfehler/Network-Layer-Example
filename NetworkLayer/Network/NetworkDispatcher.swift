//
//  Dispatcher.swift
//  NetworkLayer
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

public enum DispatcherError: Swift.Error {
    case invalidURL
    case noHTTPResponse
    case httpStatus(Int)
    case noData
}

public struct NetworkDispatcher: Dispatcher {

    let baseURL: URL
    let session: URLSession

    public init(baseURL: URL, session: URLSession = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }

    public func dispatch(request: APIRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        guard
            let requestURL = request.url(with: baseURL)
            else { completionHandler(.failure(DispatcherError.invalidURL)); fatalError() }

        var urlRequest = URLRequest(url: requestURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody   = request.body
        urlRequest.allHTTPHeaderFields = request.headers

        let dataTask = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            guard
                let data = data
                else { completionHandler(.failure(DispatcherError.noData)); return }

            guard
                let httpResponse = response as? HTTPURLResponse
                else { completionHandler(.failure(DispatcherError.noHTTPResponse)); return }

            switch httpResponse.statusCode {
            case 200 ... 299:
                completionHandler(.success(data))
            default:
                let error = DispatcherError.httpStatus(httpResponse.statusCode)
                completionHandler(.failure(error))
            }
        }

        dataTask.resume()

        return dataTask
    }
}

extension APIRequest {
    func url(with baseURL: URL) -> URL? {

        var queryParameter = [URLQueryItem]()

        if let requestQueryParameter = self.queryParameter {
            queryParameter.append(contentsOf: requestQueryParameter)
        }

        var urlComponents    = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host   = baseURL.host
        urlComponents.path   = baseURL.path + self.path
        urlComponents.queryItems = queryParameter

        let requestURL = urlComponents.url

        return requestURL
    }
}
