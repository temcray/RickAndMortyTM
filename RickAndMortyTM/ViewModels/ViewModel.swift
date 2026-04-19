//
//  BrowseViewModel.swift
//  RickAndMortyTM
//
//  Created by Tatiana6mo on 3/28/26.
//

import Foundation

@MainActor
class BrowseViewModel: ObservableObject {

    @Published var selectedResource: RMResource = .characters
    @Published var searchText: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1

    @Published var characters: [RMCharacter] = []
    @Published var episodes: [RMEpisode] = []
    @Published var locations: [RMLocation] = []

    private let api: RMAPIService = RMAPIService()

    private var currentTask: Task<Void, Never>? = nil

    // MARK: - Public Actions

    func startFreshLoad() {
        cancelInFlightRequest()

        errorMessage = ""
        currentPage = 1
        totalPages = 1

        clearSelectedList()

        fetchPage(page: 1, appendResults: false)
    }

    func userSwitchedResource(to newResource: RMResource) {
        selectedResource = newResource
        startFreshLoad()
    }

    func userDidSearch() {
        startFreshLoad()
    }

    func canLoadMore() -> Bool {
        return currentPage < totalPages
    }

    func loadNextPage() {
        if isLoading == true { return }
        if canLoadMore() == false { return }

        cancelInFlightRequest()

        let nextPage: Int = currentPage + 1
        fetchPage(page: nextPage, appendResults: true)
    }

    func selectedCount() -> Int {
        if selectedResource == .characters {
            return characters.count
        } else if selectedResource == .episodes {
            return episodes.count
        } else {
            return locations.count
        }
    }

    // MARK: - Private Helpers

    private func cancelInFlightRequest() {
        if currentTask != nil {
            currentTask?.cancel()
            currentTask = nil
        }
    }

    private func clearSelectedList() {
        if selectedResource == .characters {
            characters = []
        } else if selectedResource == .episodes {
            episodes = []
        } else {
            locations = []
        }
    }

    private func nameFilterOrNil() -> String? {
        if searchText.isEmpty == true {
            return nil
        } else {
            return searchText
        }
    }

    private func fetchPage(page: Int, appendResults: Bool) {

        isLoading = true
        errorMessage = ""

        let filter: String? = nameFilterOrNil()
        let resourceAtStart: RMResource = selectedResource

        currentTask = Task {
            do {
                if resourceAtStart == .characters {

                    let response: CharacterResponse = try await api.fetchCharacters(page: page, name: filter)

                    if selectedResource == resourceAtStart {
                        applyCharacters(response: response, page: page, appendResults: appendResults)
                    }

                } else if resourceAtStart == .episodes {

                    let response: EpisodeResponse = try await api.fetchEpisodes(page: page, name: filter)

                    if selectedResource == resourceAtStart {
                        applyEpisodes(response: response, page: page, appendResults: appendResults)
                    }

                } else {

                    let response: LocationResponse = try await api.fetchLocations(page: page, name: filter)

                    if selectedResource == resourceAtStart {
                        applyLocations(response: response, page: page, appendResults: appendResults)
                    }
                }

            } catch is CancellationError {
                // We cancelled on purpose. No UI error needed.

            } catch let apiError as RMAPIError {
                handleApiError(apiError: apiError)

            } catch {
                errorMessage = "Something went wrong. Try again."
            }

            isLoading = false
        }
    }

    private func applyCharacters(response: CharacterResponse, page: Int, appendResults: Bool) {
        currentPage = page
        totalPages = response.info.pages

        if appendResults == true {
            for item in response.results {
                characters.append(item)
            }
        } else {
            characters = response.results
        }
    }

    private func applyEpisodes(response: EpisodeResponse, page: Int, appendResults: Bool) {
        currentPage = page
        totalPages = response.info.pages

        if appendResults == true {
            for item in response.results {
                episodes.append(item)
            }
        } else {
            episodes = response.results
        }
    }

    private func applyLocations(response: LocationResponse, page: Int, appendResults: Bool) {
        currentPage = page
        totalPages = response.info.pages

        if appendResults == true {
            for item in response.results {
                locations.append(item)
            }
        } else {
            locations = response.results
        }
    }

    private func handleApiError(apiError: RMAPIError) {

        switch apiError {
        case .noResults:
            errorMessage = "No results found."
            totalPages = 1

        case .badStatusCode(let code):
            errorMessage = "Server error. Status code: \(code)"

        case .invalidUrl:
            errorMessage = "Invalid URL."

        case .invalidResponse:
            errorMessage = "Invalid server response."

        case .requestFailed:
            errorMessage = "Request failed. Check your internet."

        case .decodingFailed:
            errorMessage = "Could not decode the response."
        }
    }
}
