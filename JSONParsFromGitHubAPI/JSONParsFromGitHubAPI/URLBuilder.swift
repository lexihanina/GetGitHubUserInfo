//
//  URLBuilder.swift
//  JSONParsFromGitHubAPI
//
//  Created by Lexi Hanina on 28.01.24.
//

import Foundation

class URLBuilder {
    private var componenets = URLComponents()
    
    init() {
        componenets.scheme = "http"
        componenets.host = "api.github.com"
    }
    
    func usersPath() -> Self {
        componenets.path = "/users"
        return self
    }
    
    func exact(user: String) -> Self {
        componenets.path.append("/\(user)")
        return self
    }
    
    func build() -> URL? {
        componenets.url
    }
}
