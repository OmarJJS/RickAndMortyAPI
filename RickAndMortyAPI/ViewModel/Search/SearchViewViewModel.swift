//
//  SearchViewViewModel.swift
//  RickAndMortyAPI
//
//  Created by Omar Jiménez Sotelo on 23/02/24.
//

import Foundation

final class SearchViewViewModel {
    let config: SearchViewController.Config
    private var optionMap: [SearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""

    private var optionMapUpdateBlock: (((SearchInputViewViewModel.DynamicOption, String)) -> Void)?

    private var searchResultHandler: ((SearchResultViewModel) -> Void)?

    private var noResultsHandler: (() -> Void)?

    private var searchResultModel: Codable?

    // MARK: - Init

    init(config: SearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public

    public func registerSearchResultHandler(_ block: @escaping (SearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }

    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }

    public func executeSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        var value = optionMap.enumerated().compactMap({_, element in
            let key:
            SearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        })
        for valueOption in value{
            if valueOption.value != "All" {
                queryParams.append(valueOption)
            }
        }
        
        let request = Request(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )

        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(GetAllCharactersResponse.self, request: request)
        case .episode:
            makeSearchAPICall(GetAllEpisodesResponse.self, request: request)
        case .location:
            makeSearchAPICall(GetAllLocationsResponse.self, request: request)
        }
    }

    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: Request) {
        Service.shared.execute(request, expecting: type) { [weak self] result in

            switch result {
            case .success(let model):
                self?.processSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }

    private func processSearchResults(model: Codable) {
        var resultsVM: SearchResultType?
        var nextUrl: String?
        if let characterResults = model as? GetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                return CharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )
            }))
            nextUrl = characterResults.info.next
        }
        else if let episodesResults = model as? GetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.results.compactMap({
                return CharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: $0.url)
                )
            }))
            nextUrl = episodesResults.info.next
        }
        else if let locationsResults = model as? GetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.compactMap({
                return LocationTableViewCellViewModel(location: $0)
            }))
            nextUrl = locationsResults.info.next
        }

        if let results = resultsVM {
            self.searchResultModel = model
            let vm = SearchResultViewModel(results: results, next: nextUrl)
            self.searchResultHandler?(vm)
        } else {
            handleNoResults()
        }
    }

    private func handleNoResults() {
        noResultsHandler?()
    }

    public func set(query text: String) {
        self.searchText = text
    }

    public func set(value: String, for option: SearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    public func registerOptionChangeBlock(
        _ block: @escaping ((SearchInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionMapUpdateBlock = block
    }

    public func locationSearchResult(at index: Int) -> Location? {
        guard let searchModel = searchResultModel as? GetAllLocationsResponse else {
            return nil
        }
        return searchModel.results[index]
    }

    public func characterSearchResult(at index: Int) -> Characters? {
        guard let searchModel = searchResultModel as? GetAllCharactersResponse else {
            return nil
        }
        return searchModel.results[index]
    }

    public func episodeSearchResult(at index: Int) -> Episode? {
        guard let searchModel = searchResultModel as? GetAllEpisodesResponse else {
            return nil
        }
        return searchModel.results[index]
    }
}
