//
//  CharacterDetailView.swift
//  RickAndMortyAPI
//
//  Created by Omar Jiménez Sotelo on 23/02/24.
//

import UIKit

final class CharacterDetailView: UIView {

        public var collectionView: UICollectionView?

        private let viewModel: CharacterDetailViewViewModel

        private let spinner: UIActivityIndicatorView = {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.hidesWhenStopped = true
            spinner.translatesAutoresizingMaskIntoConstraints = false
            return spinner
        }()

        // MARK: - Init

        init(frame: CGRect, viewModel: CharacterDetailViewViewModel) {
            self.viewModel = viewModel
            super.init(frame: frame)
            translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = .systemBackground
            let collectionView = createCollectionView()
            self.collectionView = collectionView
            addSubviews(collectionView, spinner)
            addConstraints()
        }

        required init?(coder: NSCoder) {
            fatalError("Unsupported")
        }

        private func addConstraints() {
            guard let collectionView = collectionView else {
                return
            }

            NSLayoutConstraint.activate([
                spinner.widthAnchor.constraint(equalToConstant: 100),
                spinner.heightAnchor.constraint(equalToConstant: 100),
                spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

                collectionView.topAnchor.constraint(equalTo: topAnchor),
                collectionView.leftAnchor.constraint(equalTo: leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }

        private func createCollectionView() -> UICollectionView {
            let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
                return self.createSection(for: sectionIndex)
            }
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(CharacterPhotoCollectionViewCell.self,
                                    forCellWithReuseIdentifier: CharacterPhotoCollectionViewCell.cellIdentifer)
            collectionView.register(CharacterInfoCollectionViewCell.self,
                                    forCellWithReuseIdentifier: CharacterInfoCollectionViewCell.cellIdentifer)
            collectionView.register(CharacterEpisodeCollectionViewCell.self,
                                    forCellWithReuseIdentifier: CharacterEpisodeCollectionViewCell.cellIdentifer)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }

        private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
            let sectionTypes = viewModel.sections
            switch sectionTypes[sectionIndex]  {
            case .photo:
                return viewModel.createPhotoSectionLayout()
            case .information:
                return viewModel.createInfoSectionLayout()
            case .episodes:
                return viewModel.createEpisodeSectionLayout()
            }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
