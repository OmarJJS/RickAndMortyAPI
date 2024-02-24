//
//  TableLoadingFooterView.swift
//  RickAndMortyAPI
//
//  Created by Omar Jiménez Sotelo on 23/02/24.
//

import UIKit

final class TableLoadingFooterView: UIView {

        private let spinner: UIActivityIndicatorView = {
            let spinner = UIActivityIndicatorView()
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.hidesWhenStopped = true
            return spinner
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)

            addSubview(spinner)
            spinner.startAnimating()

            addConstraints()
        }

        required init?(coder: NSCoder) {
            fatalError()
        }

        private func addConstraints() {
            NSLayoutConstraint.activate([
                spinner.widthAnchor.constraint(equalToConstant: 55),
                spinner.heightAnchor.constraint(equalToConstant: 55),
                spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            ])
        }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
