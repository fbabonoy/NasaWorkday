//
//  NasaWorkdayTests.swift
//  NasaWorkdayTests
//
//  Created by fernando babonoyaba on 5/9/23.
//

import XCTest
import Combine
@testable import NasaWorkday

class NasaViewModelTests: XCTestCase {
    var viewModel: NasaViewModel!
    var serviceCall: MockNasaService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        serviceCall = MockNasaService()
        viewModel = NasaViewModel(serviceCall: serviceCall)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        super.tearDown()
        serviceCall = nil
        viewModel = nil
        cancellables = nil
    }

    func testFetchDataSuccess() {
        let expectation = XCTestExpectation(description: "Fetch data success")

        viewModel.$results
            .dropFirst()
            .sink { posts in
                XCTAssertGreaterThan(posts.count, 0)
                XCTAssertEqual(posts.first?.title, "Apollo 11 spacecraft pre-launch")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadAllPosts()

        wait(for: [expectation], timeout: 1.0)
    }

}

class MockNasaService: NasaServiceCallProtocol {

    func getAllData(page: Int) -> AnyPublisher<[NasaWorkday.NasaData], Error> {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            return Fail(error: NasaServiceError.invalidResponse).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, _ in
                return data
            }
            .decode(type: NasaResponse.self, decoder: JSONDecoder())
            .map { response in
                let items = response.collection.items.filter { $0.data.first?.mediaType == .image }
                let nasaPosts = items.compactMap { item -> NasaData? in
                    guard let title = item.data.first?.title else {
                        return nil
                    }

                    let description = item.data.first?.description
                    let imageUrl = item.links.first?.href
                    let dateCreated = self.getFormattedDate(dateCreated: item.data.first?.dateCreated)

                    return NasaData(title: title, description: description, image: imageUrl ?? "", date: dateCreated)
                    }

                return nasaPosts
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
