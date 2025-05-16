//
//  FetchPokemonService.swift
//  Pokedex
//
//  Created by Eduardo Gonzalez Melgoza on 15/05/25.
//

import Foundation

/// Service responsible for fetching Pokemon objects from the PokéAPI.
struct FetchPokemonService: FetchPokemonServiceProtocol {
    enum FetchError: Error {
        case badResponse
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    /// Fetches Pokemon by ID from the PokéAPI.
    ///
    /// - Parameter id: ID of Pokemon to retrieve.
    /// - Returns: A `Pokemon` object containing the fetched data.
    /// - Throws: A `FetchError.badResponse` if the server response is invalid,
    ///           or any error encountered during data retrieval or decoding.
    func fetchPokemon(_ id: Int) async throws -> Pokemon {
        let fetchURL = baseURL.appending(path: String(id))
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        
        let pokemon = try decoder.decode(Pokemon.self, from: data)
        
//        print("Fetched \(pokemon.id): \(pokemon.name.capitalized)")
        
        return pokemon
    }
}
