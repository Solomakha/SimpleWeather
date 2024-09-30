//
//  Coordinator.swift
//  SimpleWeather
//
//  Created by Дмитрий Соломаха on 28.09.2024.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
