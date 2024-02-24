//
//  SearchViewDelegate.swift
//  RickAndMortyAPI
//
//  Created by Omar Jiménez Sotelo on 23/02/24.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func SearchView(_ searchView: SearchView, didSelectOption option: SearchInputViewViewModel.DynamicOption)

    func SearchView(_ searchView: SearchView, didSelectLocation location: Location)
    func SearchView(_ searchView: SearchView, didSelectCharacter character: Characters)
    func SearchView(_ searchView: SearchView, didSelectEpisode episode: Episode)
}

final class SearchView: UIView {

    weak var delegate: SearchViewDelegate?

    private let viewModel: SearchViewViewModel

    // MARK: - Subviews

    private let searchInputView = RickAndMortyAPI.SearchInputView()

    private let noResultsView = NoSearchResultsView()

    private let resultsView = RickAndMortyAPI.SearchResultsView()

    // MARK: - Init

    init(frame: CGRect, viewModel: SearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultsView, noResultsView, searchInputView)
        addConstraints()

        searchInputView.configure(with: SearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self

        setUpHandlers(viewModel: viewModel)

        resultsView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setUpHandlers(viewModel: SearchViewViewModel) {
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }

        viewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: result)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }

        viewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),

            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),

            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

// MARK: - CollectionView

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)


    }
}

// MARK: - SearchInputViewDelegate

extension SearchView: SearchInputViewDelegate {
    func SearchInputView(_ inputView: SearchInputView, didSelectOption option: SearchInputViewViewModel.DynamicOption) {
        delegate?.SearchView(self, didSelectOption: option)
    }

    func SearchInputView(_ inputView: SearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }

    func SearchInputViewDidTapSearchKeyboardButton(_ inputView: SearchInputView) {
        viewModel.executeSearch()
    }
}

// MARK: - SearchResultsViewDelegate

extension SearchView: SearchResultsViewDelegate {
    func SearchResultsView(_ resultsView: SearchResultsView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else {
            return
        }
        delegate?.SearchView(self, didSelectLocation: locationModel)
    }

    func SearchResultsView(_ resultsView: SearchResultsView, didTapEpisodeAt index: Int) {
        guard let episodeModel = viewModel.episodeSearchResult(at: index) else {
            return
        }
        delegate?.SearchView(self, didSelectEpisode: episodeModel)
    }

    func SearchResultsView(_ resultsView: SearchResultsView, didTapCharacterAt index: Int) {
        guard let characterModel = viewModel.characterSearchResult(at: index) else {
            return
        }
        delegate?.SearchView(self, didSelectCharacter: characterModel)
    }
}
