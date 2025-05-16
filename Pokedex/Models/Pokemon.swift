//
//  Pokemon.swift
//  Pokedex
//
//  Created by Eduardo Gonzalez Melgoza on 14/05/25.
//

import Foundation

struct Pokemon: Decodable, Identifiable {
    let id: Int
    let name: String
    let types: [String]
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttack: Int
    let specialDefense: Int
    let speed: Int
    let spriteURL: URL
    let shinyURL: URL
    let moves: [String]
    let abilities: [String]
    let weight: Int
    let height: Int
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        case moves
        case abilities
        case weight
        case height
        
        enum TypeDictionaryKeys: CodingKey {
            case type
            enum TypeKeys: CodingKey {
                case name
            }
        }
        
        enum StatsDictionaryKeys: String, CodingKey {
            case baseStat = "base_stat"
            case stat
            enum StatKeys: CodingKey {
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey {
            case spriteURL = "front_default"
            case shinyURL = "front_shiny"
        }
        
        enum MovesDictionaryKeys: CodingKey {
            case move
            enum MoveKeys: CodingKey {
                case name
            }
        }
        
        enum AbilitiesDictionaryKeys: CodingKey {
            case ability
            enum AbilityKeys: CodingKey {
                case name
            }
        }
    }
    
    /// Decodes JSON data into the attributes of a Pokemon object.
    ///
    /// Handles deeply nested objects and arrays to extract properties.
    ///
    /// - Parameter decoder: The decoder used to extract values from JSON.
    /// - Throws: An error if decoding any of the required values fails.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        height = try container.decode(Int.self, forKey: .height)
        weight = try container.decode(Int.self, forKey: .weight)
        
        // Decode types
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typeContainer = try typesContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.self)
            let typeNameContainer = try typeContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            let typeName = try typeNameContainer.decode(String.self, forKey: .name)
            decodedTypes.append(typeName)
        }
        types = decodedTypes
        
        // Decode stats
        var decodedStatsDict: [String: Int] = [:]
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statContainer = try statsContainer.nestedContainer(keyedBy: CodingKeys.StatsDictionaryKeys.self)
            let baseStat = try statContainer.decode(Int.self, forKey: .baseStat)
            let statNameContainer = try statContainer.nestedContainer(keyedBy: CodingKeys.StatsDictionaryKeys.StatKeys.self, forKey: .stat)
            let statName = try statNameContainer.decode(String.self, forKey: .name)
            decodedStatsDict[statName] = baseStat
        }
        
        hp = decodedStatsDict["hp"] ?? 0
        attack = decodedStatsDict["attack"] ?? 0
        defense = decodedStatsDict["defense"] ?? 0
        specialAttack = decodedStatsDict["special-attack"] ?? 0
        specialDefense = decodedStatsDict["special-defense"] ?? 0
        speed = decodedStatsDict["speed"] ?? 0
        
        // Decode sprites
        let spriteContainer = try container.nestedContainer(keyedBy: CodingKeys.SpriteKeys.self, forKey: .sprites)
        spriteURL = try spriteContainer.decode(URL.self, forKey: .spriteURL)
        shinyURL = try spriteContainer.decode(URL.self, forKey: .shinyURL)
        
        // Decode moves
        var decodedMoves: [String] = []
        var movesContainer = try container.nestedUnkeyedContainer(forKey: .moves)
        while !movesContainer.isAtEnd {
            let moveContainer = try movesContainer.nestedContainer(keyedBy: CodingKeys.MovesDictionaryKeys.self)
            let moveNameContainer = try moveContainer.nestedContainer(keyedBy: CodingKeys.MovesDictionaryKeys.MoveKeys.self, forKey: .move)
            let moveName = try moveNameContainer.decode(String.self, forKey: .name)
            decodedMoves.append(moveName.replacingOccurrences(of: "-", with: " "))
        }
        moves = decodedMoves
        
        // Decode abilities
        var decodedAbilities: [String] = []
        var abilitiesContainer = try container.nestedUnkeyedContainer(forKey: .abilities)
        while !abilitiesContainer.isAtEnd {
            let abilityContainer = try abilitiesContainer.nestedContainer(keyedBy: CodingKeys.AbilitiesDictionaryKeys.self)
            let abilityNameContainer = try abilityContainer.nestedContainer(keyedBy: CodingKeys.AbilitiesDictionaryKeys.AbilityKeys.self, forKey: .ability)
            let abilityName = try abilityNameContainer.decode(String.self, forKey: .name)
            decodedAbilities.append(abilityName.replacingOccurrences(of: "-", with: " "))
        }
        abilities = decodedAbilities
    }
}
