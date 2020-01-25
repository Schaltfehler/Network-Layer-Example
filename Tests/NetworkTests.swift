//
//  DispatchTests.swift
//  DispatchTests
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import XCTest
@testable import NetworkLayer

class DispatchTests: XCTestCase {

    func testCanGetUsers() {
        let expectation = self.expectation(description: "Get some Users")
        var receivedUsers: [User]?

        let response = MockData.users
        let dispatcher = MockDispatcher(path: "/users/", response: response)
        let client = Client(dispatcher: dispatcher)

        client.users(page: 1, perPage: 10) { result in
            switch result {
            case .success(let users):
                receivedUsers = users
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 100, handler: nil)

        XCTAssertEqual(receivedUsers?.count, 2)
    }


}
