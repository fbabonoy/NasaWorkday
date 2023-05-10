//
//  NasaServiceCall.swift
//  NasaWorkday
//
//  Created by fernando babonoyaba on 5/9/23.
//

import Foundation
import Combine

enum NasaServiceError: Error {
    case invalidResponse
    case invalidEndpoint
}

protocol NasaServiceCallProtocol {
    func getAllData() -> AnyPublisher<[NasaData], Error>
}

struct NasaServiceCall: NasaServiceCallProtocol {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
    func getAllData() -> AnyPublisher<[NasaData], Error> {
        let endpoint = "https://images-api.nasa.gov/search?q=apollo%2011&description=moon%20landing&media_type=image"

        guard let url = URL(string: endpoint) else {
            return Fail(error: NasaServiceError.invalidEndpoint).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw NasaServiceError.invalidResponse
                }
                return data
            }
            .decode(type: NasaResponse.self, decoder: JSONDecoder())
            .map { response in
                let items = response.collection.items.filter { $0.data.first?.mediaType == .image }
                let breeds = items.compactMap { item -> NasaData? in
                    guard let title = item.data.first?.title else {
                        return nil
                    }

                    let description = item.data.first?.description
                    let imageUrl = item.links.first?.href

                    return NasaData(title: title, description: description, href: imageUrl ?? "")
                    }

                return breeds
            }
            .eraseToAnyPublisher()
    }
}
