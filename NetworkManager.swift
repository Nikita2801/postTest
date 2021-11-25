//
//  NetworkManager.swift
//  TablePostApp
//
//  Created by 1 on 12.11.2021.
// "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/main.json"

import Foundation

class RawNetworkManager {
    
    private let session = URLSession.shared
    
    private let baseUrl: URL = URL(string: "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/main.json")!
    
    func getPost(completion: @escaping ((Result<[Post], Error>) -> Void)) {
        let request = getRequest(url: baseUrl, method: "GET", data: nil)
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard (response as? HTTPURLResponse) != nil else { return }
            
                if let data = data {
                    do {
                        let postResponses = try JSONDecoder().decode(Posts.self, from: data)
                        completion(.success(postResponses.posts))
                    } catch {
                        completion(.failure(error))
                    }
                }
            
        }
        .resume()
    }
    
    
    
    private func getRequest(url: URL, method: String, data: Data?) -> URLRequest {
        var request = URLRequest(url: url)

        request.httpBody = data
        request.httpMethod = method

        return request
    }

}

