//
//  LoginOperation.swift
//  NetworkLayer
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

class LoginOperation: AsyncOperation {
    let apiClient: Client

    let user: String
    let password: String

    var result: Result<AuthToken, Error>?
    var task: URLSessionTask?

    init(apiClient: Client, user: String, password: String) {
        self.apiClient = apiClient
        self.user = user
        self.password = password
    }

    override func main() {
        task = apiClient.login(user: user, password: password) {[unowned self] result in
            if self.isCancelled {
                self.finish(with: .failure(OperationError.canceled))
                return
            }
            
            self.finish(with: result)
        }
    }

    override func cancel() {
        super.cancel()
        task?.cancel()
    }

    func finish(with result: Result<AuthToken, Error>) {
        self.result = result
        finish()
    }
}
