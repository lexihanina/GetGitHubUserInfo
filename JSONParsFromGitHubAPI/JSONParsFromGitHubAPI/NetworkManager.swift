//
//  NetworkManager.swift
//  JSONParsFromGitHubAPI
//
//  Created by Lexi Hanina on 28.01.24.
//

import Foundation

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    
    private init() {}
    
    func makeGETRequest(withUrl: URL?) async throws -> Data {
        guard let url = withUrl else {
            throw Errors.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200
        else {
            throw Errors.invalidResponse
        }
        
        return data
    }
}
