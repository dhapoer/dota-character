//
//  MainMenuViewModel.swift
//  character
//
//  Created by abimanyu on 22/01/21.
//

import Foundation
import Combine

class MainMenuViewModel {
    
    private var service = ApiService()
    private var disposable = Set<AnyCancellable>()
    
    func getDotaData(completion: @escaping (Result<[DotaModel], Error>) -> ()){
        service.getHeroData()
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure(let err):
                    print("generic error")
                    completion(.failure(err))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                completion(.success(data))
            })
            .store(in: &disposable)
    }
}
