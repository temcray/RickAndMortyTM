//
//  CharactersViewModel.swift
//  RickAndMortyTM
//
//  Created by Tatiana6mo on 3/28/26.
//




import Foundation

// @MainActor means: all UI updates happen on the main thread.
@MainActor
class CharactersViewModel: ObservableObject {

    @Published var characters: [RMCharacter] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let apiService: RMAPIService = RMAPIService()

    private var currentPage: Int = 1
    private var totalPages: Int = 1

    // Called when the app loads, or when the user does a new search.
    func loadFirstPage() async {
        // Reset state
        currentPage = 1
        totalPages = 1
        characters = []
        errorMessage = ""

        await loadPage(page: currentPage, appendResults: false)
    }

    // Called when user presses "Load More"
    func loadNextPage() async {
        if isLoading == true {
            return
        }

        if currentPage >= totalPages {
            return
        }

        currentPage = currentPage + 1
        await loadPage(page: currentPage, appendResults: true)
    }

    func canLoadMore() -> Bool {
        return currentPage < totalPages
    }

    // This is the function that actually calls the API and updates the list.
    private func loadPage(page: Int, appendResults: Bool) async {
        isLoading = true
        errorMessage = ""

        // If searchText is empty, we do not pass name filter.
        var nameFilter: String? = nil
        if searchText.isEmpty == false {
            nameFilter = searchText
        }

        do {
            let response: CharacterResponse = try await apiService.fetchCharacters(page: page, name: nameFilter)

            // Update total pages based on API response
            totalPages = response.info.pages

            // Add or replace results
            if appendResults == true {
                characters.append(contentsOf: response.results)
            } else {
                characters = response.results
            }

        } catch let apiError as RMAPIError {
            if apiError == RMAPIError.noResults {
                characters = []
                errorMessage = "No characters found."
                totalPages = 1
            } else {
                errorMessage = "Network error. Try again."
            }
        } catch {
            errorMessage = "Network error. Try again."
        }

        isLoading = false
    }
}
