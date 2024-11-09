//
//  HomeViewModelTests.swift
//  CocktailpediaTests
//
//  Created by Awani Melvyn on 16/09/2022.
//

import Combine
import XCTest

@testable import Cocktailpedia

class HomeViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    let mockNetworkManager: Networkable = MockNetworkManager()
    override func setUpWithError() throws {
        cancellables = []
    }

    override func tearDownWithError() throws {
        cancellables = []
    }

    func testInformNetworkManagerToPerformRequest() throws {
        let homeVieModel = HomeViewModel(networkManager: MockNetworkManager())
        XCTAssertEqual(homeVieModel.drinks.count, 0)
        homeVieModel.informNetworkManagerToPerformRequest(textEntered: "mojito")

        let promise = expectation(description: "State = pass")

        homeVieModel.$state.sink { _ in
            XCTFail()
        } receiveValue: { state in
            print(state)
            if state == .pass {
                promise.fulfill()
            }
        }.store(in: &cancellables)
        wait(for: [promise], timeout: 5)
        XCTAssertEqual(homeVieModel.drinks.count, 4)
    }
}
