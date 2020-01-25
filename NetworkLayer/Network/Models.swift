//
//  Models.swift
//  NetworkLayer
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

public struct User: Codable {
    let id: Int
    let name: String
    let age: Int
}

public struct AuthToken: Codable, Hashable {
    let key: String
}
