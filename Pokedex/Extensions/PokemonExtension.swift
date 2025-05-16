//
//  PokemonExtension.swift
//  Pokedex
//
//  Created by Eduardo Gonzalez Melgoza on 15/05/25.
//

import SwiftUI

extension Pokemon {
    
    /// Returns a color based on the Pokémon's primary type.
    ///
    /// - For Normal/Flying types, the color is based on the flying type.
    /// - For all others, it iss based on the first type.
    var typeColor: Color {
        if (types.count == 2) && (types[0] == "normal" && types[1] == "flying") {
            Color(types[1])
        } else {
            Color(types[0])
        }
    }
    
    /// An array of the Pokémon's stats mapped to `Stat` objects.
    ///
    /// Useful to use the name of the stats in views alongside their values.
    var stats: [Stat] {
        [
            Stat(id: 1, name: "HP", value: hp),
            Stat(id: 2, name: "Attack", value: attack),
            Stat(id: 3, name: "Defense", value: defense),
            Stat(id: 4, name: "Special Attack", value: specialAttack),
            Stat(id: 5, name: "Special Defense", value: specialDefense),
            Stat(id: 6, name: "Speed", value: speed)
        ]
    }
    
    /// Returns the stat with the highest value.
    var highestStat: Stat {
        stats.max { $0.value > $1.value }!
    }
}

/// Model defining individual stats structure.
struct Stat: Identifiable {
    let id: Int
    let name: String
    let value: Int
}
