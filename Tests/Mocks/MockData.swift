//
//  MockData.swift
//  Tests
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

struct MockData {}

extension MockData {
    static let users: Data = {
        let jsonString = """
[
  {
    "id": 1,
    "name": "Freddy",
    "age": 123
  },
  {
    "id": 2,
    "name": "Freddi",
    "age": 123
  }
]
"""
        return jsonString.data(using: .utf8)!
    }()

}
