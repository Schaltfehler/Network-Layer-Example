//
//  Client+Requests.swift
//  NetworkLayer
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

public extension Client {
    @discardableResult
    func login(user: String, password: String, completionHandler: @escaping (Result<AuthToken, Error>) -> Void)
        -> URLSessionTask {
            let request = APIRequest.login(user: user, password: password)
            let task = execute(request: request, completionHandler: completionHandler)

            return task
    }

    @discardableResult
    func user(token: String, completionHandler: @escaping (Result<User, Error>) -> Void)
        -> URLSessionTask {
            let request = APIRequest.user(token: token)
            let task = execute(request: request, completionHandler: completionHandler)

            return task
    }

    @discardableResult
    func users(page: Int, perPage: Int, completionHandler: @escaping (Result<[User], Error>) -> Void)
        -> URLSessionTask {
            let request = APIRequest.users(page: page, perPage: perPage)
            let task = execute(request: request, completionHandler: completionHandler)
            
            return task
    }
}
