//
//  ZerotierStatusAPI.swift
//  ZerotierStatus
//
//  Created by Cocoa on 24/03/2024.
//

import Foundation

class ZerotierStatusAPI {
    class func getZeroTierNetworkMembers(apiToken: String, networkId: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://my.zerotier.com/api/v1/network/\(networkId)/member"
        sendRequest(apiToken: apiToken, urlString: urlString, completion: completion)
    }
    
    class func getZeroTierNetworkIDs(apiToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://api.zerotier.com/api/v1/network"
        sendRequest(apiToken: apiToken, urlString: urlString, completion: completion)
    }
    
    class func sendRequest(apiToken: String, urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            }
        }
        
        task.resume()
    }
}
