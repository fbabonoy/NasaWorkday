//
//  NasaViewModel.swift
//  NasaWorkday
//
//  Created by fernando babonoyaba on 5/9/23.
//

import Foundation
import Combine

enum NasaViewModelState {
    case loading
    case loaded(loaded: [NasaData])
    case error(Error)
    case empty(String)
}

class NasaViewModel: ObservableObject {
    private let serviceCall: NasaServiceCallProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var state: NasaViewModelState = .loading
    @Published var hasMoreResults = true
    @Published var results = [NasaData]()

    init(serviceCall: NasaServiceCallProtocol = NasaServiceCall()) {
        self.serviceCall = serviceCall
    }

    func loadAllBreeds() {
        guard hasMoreResults else { return }

        state = .loading

        serviceCall.getAllData()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error)
                }
            } receiveValue: { [weak self] nasaPost in
                guard let self = self else { return }

                self.results.append(contentsOf: nasaPost)

                if nasaPost.isEmpty {
                    self.hasMoreResults = false
                }

                self.state = .loaded(loaded: self.results)

            }
            .store(in: &cancellables)
    }
}
