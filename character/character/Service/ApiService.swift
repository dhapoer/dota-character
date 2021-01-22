//
//  ApiService.swift
//  character
//
//  Created by abimanyu on 22/01/21.
//

import Foundation
import Combine

let baseURL = "https://api.opendota.com/api"

enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason):
            return reason
        }
    }
}

class ApiService {
    
    func getHeroData() -> AnyPublisher<[DotaModel], Error> {
        let apiURL = URL(string: baseURL + "/herostats")
        var request = URLRequest(url: apiURL!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw APIError.unknown
                }
                let data = try? JSONDecoder().decode([DotaModel].self, from: result.data)
                return data!
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
