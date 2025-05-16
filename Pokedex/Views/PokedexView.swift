//
//  ContentView.swift
//  Pokedex
//
//  Created by Eduardo Gonzalez Melgoza on 14/05/25.
//

import SwiftUI

struct PokedexView: View {
    @StateObject private var viewModel = FetchPokemonViewModel(service: FetchPokemonService())
    
    @State private var searchText = ""
    
    var filteredPokemon: [Pokemon] {
        if searchText.isEmpty {
            return viewModel.pokedex
        } else {
            return viewModel.pokedex.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredPokemon, id: \.id) { pokemon in
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                        HStack {
                            AsyncImage(url: pokemon.spriteURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            
                            VStack(alignment: .leading) {
                                Text(pokemon.name.capitalized)
                                    .bold()
                                
                                HStack {
                                    ForEach(pokemon.types, id: \.self) { type in
                                        Text(type.capitalized)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black)
                                            .padding(.horizontal, 13)
                                            .padding(.vertical, 5)
                                            .background(Color(type))
                                            .clipShape(.capsule)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pokédex")
            .searchable(text: $searchText, prompt: "Search by name")
            .autocorrectionDisabled()
            .animation(.default, value: searchText)
        }
        .task {
            viewModel.fetchPokemon()
        }
    }
}


#Preview {
    PokedexView()
}
