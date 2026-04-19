//
//  BrowseView.swift
//  RickAndMortyTM
//
//  Created by Tatiana6mo on 3/28/26.
//


import SwiftUI

struct BrowseView: View {

    @StateObject private var viewModel: ViewModel = ViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {

                ResourcePickerView(
                    selectedResource: $viewModel.selectedResource,
                    onChange: { newValue in
                        viewModel.userSwitchedResource(to: newValue)
                    }
                )

                SearchInfoView(
                    currentPage: viewModel.currentPage,
                    totalPages: viewModel.totalPages
                )

                if viewModel.isLoading == true && viewModel.selectedCount() == 0 {
                    LoadingStateView()
                } else {
                    ListContentView(viewModel: viewModel)
                }
            }
            .navigationTitle("Browse")
            .searchable(text: $viewModel.searchText, prompt: "Search by name")
            .onSubmit(of: .search) {
                viewModel.userDidSearch()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Search") {
                        viewModel.userDidSearch()
                    }
                }
            }
            .onAppear {
                viewModel.startFreshLoad()
            }
        }
    }
}

// MARK: - Small Views

struct ResourcePickerView: View {

    @Binding var selectedResource: RMResource
    let onChange: (RMResource) -> Void

    var body: some View {
        Picker("Resource", selection: $selectedResource) {
            ForEach(RMResource.allCases) { item in
                Text(item.rawValue).tag(item)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .onChange(of: selectedResource) { oldValue, newValue in
            onChange(newValue)
        }
    }
}

struct SearchInfoView: View {

    let currentPage: Int
    let totalPages: Int

    var body: some View {
        Text("Page \(currentPage) of \(totalPages)")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }
}

struct LoadingStateView: View {
    var body: some View {
        Spacer()
        ProgressView("Loading...")
        Spacer()
    }
}

struct ListContentView: View {

    @ObservedObject var viewModel: BrowseViewModel

    var body: some View {
        List {

            if viewModel.errorMessage.isEmpty == false {
                Text(viewModel.errorMessage)
                    .foregroundStyle(.red)
            }

            if viewModel.selectedResource == .characters {
                ForEach(viewModel.characters) { character in
                    NavigationLink {
                        // Keep using your existing CharacterDetailView
                        CharacterDetailView(character: character)
                    } label: {
                        CharacterRowView(character: character)
                    }
                }

            } else if viewModel.selectedResource == .episodes {
                ForEach(viewModel.episodes) { episode in
                    EpisodeRowView(episode: episode)
                }

            } else {
                ForEach(viewModel.locations) { location in
                    LocationRowView(location: location)
                }
            }

            if viewModel.isLoading == false &&
                viewModel.errorMessage.isEmpty == true &&
                viewModel.selectedCount() == 0 {

                Text("No items to show.")
                    .foregroundStyle(.secondary)
            }

            if viewModel.canLoadMore() == true && viewModel.selectedCount() > 0 {
                LoadMoreRowView(
                    isLoading: viewModel.isLoading,
                    onTap: {
                        viewModel.loadNextPage()
                    }
                )
            }
        }
    }
}

// MARK: - Rows

struct CharacterRowView: View {

    let character: RMCharacter

    var body: some View {
        HStack(spacing: 12) {

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

struct EpisodeRowView: View {

    let episode: RMEpisode

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(episode.name).font(.headline)
            Text(episode.episode + " • " + episode.air_date)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

struct LocationRowView: View {

    let location: RMLocation

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name).font(.headline)
            Text(location.type + " • " + location.dimension)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

struct LoadMoreRowView: View {

    let isLoading: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            Spacer()

            if isLoading == true {
                ProgressView()
            } else {
                Button("Load More") {
                    onTap()
                }
            }

            Spacer()
        }
    }
}
