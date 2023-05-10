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
    @Published var searchText: String = ""

    init(serviceCall: NasaServiceCallProtocol = NasaServiceCall()) {
        self.serviceCall = serviceCall
        search()
    }

    func search() {
        $searchText.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink {
                guard !$0.isEmpty else {
                    self.state = .loaded(loaded: self.results)
                    return
                }
                self.filter()
            }.store(in: &cancellables)
    }

    func filter() {
        let filteredResults = self.results.filter {
            guard let titleSearch = $0.title?.localizedCaseInsensitiveContains(searchText),
                  let descriptionSearch = $0.description?.localizedCaseInsensitiveContains(searchText),
                  let dateSearch = $0.date?.localizedCaseInsensitiveContains(searchText)
            else {
                return false
            }
            return titleSearch || descriptionSearch || dateSearch
        }
        if filteredResults.isEmpty {
            state = .empty("No results found")
        } else {
            state = .loaded(loaded: filteredResults)
        }
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
