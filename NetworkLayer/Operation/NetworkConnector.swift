//
//  ChainingOperation.swift
//  NetworkLayer
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

struct NetworkConnector {
    let user: String
    let password: String
    let client: Client

    let queue = OperationQueue.init()

    func runEverything() {
        let login = LoginOperation(apiClient: client, user: "Fredie", password: "1234")
        let getUser = GetUserOperation(apiClient: client)
        // Example of how to pass values between Operations
        let adapter = BlockOperation() {
            if let result = login.result,
                case .success(let auth) = result {
                getUser.token = auth.key
            }
        }

        adapter.addDependency(login)
        getUser.addDependency(adapter)
        getUser.completionBlock = {
            print("Finished!!")
        }

        // The order in which Operations are added to the queue doesn't matter.
        // They will be executed in the order of their dependencies
        queue.addOperations([login, getUser, adapter], waitUntilFinished: false)
    }
}
