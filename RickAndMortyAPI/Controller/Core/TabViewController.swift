//
//  ViewController.swift
//  RickAndMortyAPI
//
//  Created by Omar Jiménez Sotelo on 22/02/24.
//

import UIKit

class TabViewController: UITabBarController {
//class TabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            view.backgroundColor = .red
        setUpTabs()
    }

    private func setUpTabs(){
        let characterVC = CharacterViewController()
        let locationVC = LocationViewController()
        let episodeVC = EpisodeViewController()
        let settingsVC = SettingsViewController()
        
        characterVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodeVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        
        let navCharacter = UINavigationController(rootViewController: characterVC)
        let navLocation = UINavigationController(rootViewController: locationVC)
        let navEpisode = UINavigationController(rootViewController: episodeVC)
        let navSettings = UINavigationController(rootViewController: settingsVC)
        
        navCharacter.tabBarItem = UITabBarItem(title: "Character", image: UIImage(systemName: "person.fill.questionmark"), tag: 1)
        navLocation.tabBarItem = UITabBarItem(title: "Location", image: UIImage(systemName: "location.circle.fill"), tag: 2)
        navEpisode.tabBarItem = UITabBarItem(title: "Episode", image: UIImage(systemName: "movieclapper.fill"), tag: 3)
        navSettings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        
        
        for nav in [navCharacter,navLocation, navEpisode, navSettings] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [navCharacter, navLocation, navEpisode, navSettings],
            animated : true
        )
        
    }

}

