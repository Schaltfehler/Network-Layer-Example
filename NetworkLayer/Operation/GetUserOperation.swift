//
//  GetUserOperation.swift
//  NetworkLayer
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

final class GetUserOperation: AsyncOperation {
    let apiClient: Client
    var token: String?

    var result: Result<User, Error>?

    init(apiClient: Client, token: String? = nil) {
        self.apiClient = apiClient
        self.token = token
    }

    override func main() {
        guard let token = token
            else {
                self.result = .failure(OperationError.noInput)
                self.finish()
                return
        }

        apiClient.user(token: token) { result in
            self.result = result
            self.finish()
        }
    }
}
