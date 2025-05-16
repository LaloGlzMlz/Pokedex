//
//  FetchPokemonViewModel.swift
//  Pokedex
//
//  Created by Eduardo Gonzalez Melgoza on 15/05/25.
//

import Foundation
import SwiftUI


/// A protocol that defines the nature of a service for fetching Pokemon data
/// to use with the `FetchPokemonViewModel`.
protocol FetchPokemonServiceProtocol {
    
    /// Fetches a Pokemon with the given ID.
    ///
    /// - Parameter id: ID of Pokemon to fetch.
    /// - Returns: A `Pokemon` object with given ID.
    /// - Throws: An error if the fetch operation fails.
    func fetchPokemon(_ id: Int) async throws -> Pokemon
}


/// View model responsible for fetching and storing Pokemon data.
///
/// This class uses a service that has to conform to the `FetchPokemonServiceProtocol`
///  retrieve Pokemon. It exposes an observable array of Pokemon and an optional error message.
@MainActor
class FetchPokemonViewModel: ObservableObject {
    @Published var pokedex: [Pokemon] = []
    @Published var errorMessage: String?
    
    private let service: FetchPokemonServiceProtocol
    
    // Service injection
    init(service: FetchPokemonServiceProtocol = FetchPokemonService()) {
        self.service = service
    }
    
    
    /// Fetches Pokemon objects with IDs 1 to 151 and stores them in the `pokedex` array.
    ///
    /// This method clears existing data and attempts to load Pokemon from ID 1 through 151
    /// using the provided (injected) service. If successful, it updates the `pokedex`.
    /// If an error occurs, it sets the `errorMessage` property.
    func fetchPokemon() {
        Task {
            errorMessage = nil
            pokedex = []
            
            do {
                for id in 1...151 {
                    let pokemon = try await service.fetchPokemon(id)
                    pokedex.append(pokemon)
                }
            } catch {
                errorMessage = "Failed to fetch Pokemon: \(error.localizedDescription)"
            }
        }
    }
}
