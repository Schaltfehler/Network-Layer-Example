//
//  APIRequest+Service.swift
//  NetworkLayer
//
//  Created by Frederik Vogel on 2020/01/24.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation

public extension APIRequest {
    private static func encodeForBody(_ queryItems:[URLQueryItem]) -> Data? {
        var compoentents = URLComponents()
        compoentents.queryItems = queryItems
        let percentageEncoded = compoentents.url?.query
        let data = percentageEncoded?.data(using: .utf8)

        return data
    }

    // MARK: - General
    static func login(user: String, password: String) -> APIRequest {
        let queryItems = [URLQueryItem(name: "username", value: user),
                          URLQueryItem(name: "password", value: password)]
        let data = encodeForBody(queryItems)

        return APIRequest(method: .post, path: "/sessions/", body: data)
    }

    static func user(token: String) -> APIRequest {
        let queryItems = [
            URLQueryItem(name: "token", value: token)
        ]
        let data = encodeForBody(queryItems)
        return APIRequest(method: .post, path: "/user/", body: data)
    }

    static func users(page: Int, perPage: Int) -> APIRequest {
        let queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        return APIRequest(method: .get, path: "/users/", queryParameter: queryItems)
    }


}
