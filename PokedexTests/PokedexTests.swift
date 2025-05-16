//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by Eduardo Gonzalez Melgoza on 14/05/25.
//

import XCTest
@testable import Pokedex


import XCTest
@testable import Pokedex

final class FetchPokemonViewModelTests: XCTestCase {
    
    func testFetchPokemonAppendsData() async throws {
        let viewModel = await FetchPokemonViewModel(service: StubPokemonService())
        
        await viewModel.fetchPokemon()
        
        // wait for the fetch to complete
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
            XCTAssertFalse(viewModel.pokedex.isEmpty, "Pokedex should not be empty")
            XCTAssertEqual(viewModel.pokedex.count, 151, "Should have fetched 151 Pokemon")
            XCTAssertEqual(viewModel.pokedex[0].name, "ditto", "Mocked Pokemon name should be 'ditto'")
        }
    }
    
    
    func testFetchPokemonSetsErrorOnFailure() async throws {
        
        let viewModel = await FetchPokemonViewModel(service: StubFailingService())
        
        await MainActor.run {
            viewModel.fetchPokemon()
        }
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertTrue(viewModel.pokedex.isEmpty)
        }
    }
}

