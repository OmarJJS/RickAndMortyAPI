//
//  ViewController.swift
//  RickAndMortyAPI
//
//  Created by Omar Jiménez Sotelo on 22/02/24.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
            view.backgroundColor = .red
        setUpTabs()
    }

    private func setUpTabs(){
        let characterVC = CharacterViewController()
        let locationVC = LocationViewController()
        let episodeVC = EpisodeViewController()
        
        characterVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodeVC.navigationItem.largeTitleDisplayMode = .automatic
        
        
        let navCharacter = UINavigationController(rootViewController: characterVC)
        let navLocation = UINavigationController(rootViewController: locationVC)
        let navEpisode = UINavigationController(rootViewController: episodeVC)
        
        navCharacter.tabBarItem = UITabBarItem(title: "Character", image: UIImage(systemName: "person.fill.questionmark"), tag: 1)
        navLocation.tabBarItem = UITabBarItem(title: "Location", image: UIImage(systemName: "location.circle.fill"), tag: 2)
        navEpisode.tabBarItem = UITabBarItem(title: "Episode", image: UIImage(systemName: "movieclapper.fill"), tag: 3)

        
        for nav in [navCharacter,navLocation, navEpisode] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [navCharacter, navLocation, navEpisode],
            animated : true
        )
        
    }

}

