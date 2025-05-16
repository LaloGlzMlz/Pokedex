//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Eduardo Gonzalez Melgoza on 15/05/25.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    
    @State private var abilitiesExpanded = false
    @State private var movesExpanded = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack {
                    // Background ------------
                    Rectangle()
                        .foregroundStyle(pokemon.typeColor.opacity(0.5))
                        .mask(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .black.opacity(1.0), location: 0.0),
                                    .init(color: .black.opacity(0.0), location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // Pokemon sprite ------------
                    AsyncImage(url: pokemon.spriteURL) { image in
                        image
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .shadow(color: .black, radius: 6)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                // Types section ------------
                HStack {
                    ForEach(pokemon.types, id: \.self) { type in
                        Text(type.capitalized)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .padding(.vertical, 7)
                            .padding(.horizontal)
                            .background(Color(type.description))
                            .clipShape(.capsule)
                    }
                }
                .padding()
                
                // Height section ------------
                HStack {
                    Text("Height: ")
                        .bold()
                    Text("\(pokemon.height)")
                        .accessibilityIdentifier("heightLabel")
                }
                .padding(.bottom)
                .padding(.horizontal)
                
                
                // Weight section ------------
                HStack {
                    Text("Weight: ")
                        .bold()
                    Text("\(pokemon.weight)")
                }
                .padding(.bottom)
                .padding(.horizontal)
                
                
                // Stats section ------------
                Text("Stats")
                    .padding(.horizontal)
                    .bold()
                StatsView(pokemon: pokemon)
                
                // Abilities section ------------
                DisclosureGroup("Abilities", isExpanded: $abilitiesExpanded) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                        ForEach(pokemon.abilities, id: \.self) { ability in
                            Text(ability.capitalized)
                                .fontWeight(.regular)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.top)
                }
                .foregroundStyle(.primary)
                .padding()
                .bold()
                
                Divider()
                
                // Moves section ------------
                DisclosureGroup("Moves", isExpanded: $movesExpanded) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                        ForEach(pokemon.moves, id: \.self) { move in
                            Text(move.capitalized)
                                .fontWeight(.regular)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.top)
                }
                .foregroundStyle(.primary)
                .padding()
                .bold()
            }
        }
        .navigationTitle(pokemon.name.capitalized)
    }
}

//#Preview {
//    PokemonDetailView()
//}
