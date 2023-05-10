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
    func getAllData(page: Int) -> AnyPublisher<[NasaData], Error>
}

struct NasaServiceCall: NasaServiceCallProtocol {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getAllData(page: Int) -> AnyPublisher<[NasaData], Error> {
        let endpoint = "https://images-api.nasa.gov/search?media_type=image&page=\(page)&q=apollo%2011"

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
                    let dateCreated = getFormattedDate(dateCreated: item.data.first?.dateCreated)

                    return NasaData(title: title, description: description, image: imageUrl ?? "", date: dateCreated)
                    }

                return breeds
            }
            .eraseToAnyPublisher()
    }

    func getFormattedDate(dateCreated: String?) -> String {
        guard let oldDateFormat = dateCreated else { return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard let date = dateFormatter.date(from: oldDateFormat) else { return ""}
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = dateFormatter.string(from: date)

        return formattedDate
    }
}
