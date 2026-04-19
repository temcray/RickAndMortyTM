//
//  ListView.swift
//  RickAndMortyTM
//
//  Created by Tatiana6mo on 3/24/26.
//




import SwiftUI

struct ListView: View {

    @StateObject private var viewModel: CharactersViewModel = CharactersViewModel()

    var body: some View {
        NavigationStack {
            VStack {

                // Show an error message if something went wrong
                if viewModel.errorMessage.isEmpty == false {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }

                List {

                    // Show each character
                    ForEach(viewModel.characters) { character in
                        NavigationLink {
                            CharacterDetailView(character: character)
                        } label: {
                            HStack(spacing: 12) {

                                // Character image
                                if let url: URL = URL(string: character.image) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }

                                // Character name + subtitle
                                VStack(alignment: .leading) {
                                    Text(character.name)
                                        .font(.headline)

                                    Text(character.status + " • " + character.species)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }

                    // Load More section at bottom
                    if viewModel.canLoadMore() == true {
                        HStack {
                            Spacer()

                            if viewModel.isLoading == true {
                                ProgressView()
                            } else {
                                Button("Load More") {
                                    Task {
                                        await viewModel.loadNextPage()
                                    }
                                }
                            }

                            Spacer()
                        }
                    }
                }

                // Show loading text when first loading
                if viewModel.isLoading == true && viewModel.characters.isEmpty == true {
                    ProgressView("Loading...")
                        .padding()
                }
            }
            .navigationTitle("Characters")

            // Search bar
            .searchable(text: $viewModel.searchText, prompt: "Search by name")

            // When user presses Search on keyboard
            .onSubmit(of: .search) {
                Task {
                    await viewModel.loadFirstPage()
                }
            }

            // Also provide a button (some beginners prefer a button)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Search") {
                        Task {
                            await viewModel.loadFirstPage()
                        }
                    }
                }
            }

            // Load first page when screen appears
            .onAppear {
                if viewModel.characters.isEmpty == true {
                    Task {
                        await viewModel.loadFirstPage()
                    }
                }
            }
        }
    }
}
