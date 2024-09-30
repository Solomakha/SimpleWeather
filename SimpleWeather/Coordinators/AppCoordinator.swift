//
//  AppCoordinator.swift
//  SimpleWeather
//
//  Created by Дмитрий Соломаха on 28.09.2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainVC = MainScreenViewController()
        mainVC.coordinator = self
        navigationController.pushViewController(mainVC, animated: true)
    }
    
    
}
