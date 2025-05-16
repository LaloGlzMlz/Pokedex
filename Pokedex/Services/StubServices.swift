//
//  StubServices.swift
//  Pokedex
//
//  Created by Eduardo Gonzalez Melgoza on 16/05/25.
//

import Foundation

/// A stub implementation of `FetchPokemonServiceProtocol` that returns mocked Pokémon data.
///
/// To be used for testing without using real service.
class StubPokemonService: FetchPokemonServiceProtocol {
    
    /// Function that returns a mock `Pokemon` object from defined JSON data.
    ///
    /// - Parameter id: ID of  Pokemon to fetch. Will become the ID of the Ditto pokemon.
    /// - Returns: A `Pokemon` object decoded from JSON data, always Ditto.
    /// - Throws: An error if JSON serialization or decoding fails.
    func fetchPokemon(_ id: Int) async throws -> Pokemon {
        let json: [String: Any] = [
            "abilities": [
                ["ability": ["name": "limber"]],
                ["ability": ["name": "imposter"]]
            ],
            "height": 3,
            "id": id,
            "moves": [
                ["move": ["name": "transform"]]
            ],
            "name": "ditto",
            "sprites": [
                "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/132.png",
                "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/132.png"
            ],
            "stats": [
                ["base_stat": 48, "stat": ["name": "hp"]],
                ["base_stat": 48, "stat": ["name": "attack"]],
                ["base_stat": 48, "stat": ["name": "defense"]],
                ["base_stat": 48, "stat": ["name": "special-attack"]],
                ["base_stat": 48, "stat": ["name": "special-defense"]],
                ["base_stat": 48, "stat": ["name": "speed"]]
            ],
            "types": [
                ["type": ["name": "normal"]]
            ],
            "weight": 40
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        
        return try JSONDecoder().decode(Pokemon.self, from: jsonData)
    }
}

/// A stub implementation of `FetchPokemonServiceProtocol` that always throws an error.
///
/// To be used for testing error handling in the view model.
class StubFailingService: FetchPokemonServiceProtocol {
    func fetchPokemon(_ id: Int) async throws -> Pokemon {
        throw URLError(.badServerResponse)
    }
}
