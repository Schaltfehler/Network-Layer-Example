//
//  GetUsersOperation.swift
//  NetworkLayer
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

class GetUsersOperation: AsyncOperation {
    let apiClient: Client

    var result: Result<Array<User>, Error>?

    init(apiClient: Client) {
        self.apiClient = apiClient
    }

    override func main() {
        getUsers(page: 1, perPage: 30, currentUsers: [User]())
    }

    private func getUsers(page: Int, perPage: Int, currentUsers: [User]) {
        assert(page > 0, "page is not > 0")
        assert(perPage > 0, "perPage is not > 0")
        apiClient.users(page: page, perPage: perPage)
        { [unowned self] (result: Result<Array<User>, Error>) in
            if self.isCancelled {
                self.finish(with: .failure(OperationError.canceled))
                return
            }

            switch result {
            case .success(let users):
                if users.count < perPage {
                    self.finish(with: .success(currentUsers))
                } else {
                    self.getUsers(page: page + 1,
                                  perPage: perPage,
                                  currentUsers: currentUsers + users)
                }
            case .failure(let error):
                self.finish(with: .failure(error))
            }
        }
    }

    func finish(with result: Result<Array<User>, Error>) {
        self.result = result
        finish()
    }
}

