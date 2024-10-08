//
//  TabBarController.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2023/12/20.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaHeight = safeAreaInsets.bottom
        tabBar.frame.size.height += safeAreaHeight
        tabBar.frame.origin.y = view.frame.height - tabBar.frame.size.height
    }
    
    private var safeAreaInsets: UIEdgeInsets {
        guard let window: UIWindow = UIApplication.shared.windows.first else {
            return .zero
        }
        if #available(iOS 11.0, *),
           UIWindow.instancesRespond(to: #selector(getter: window.safeAreaInsets)) {
            return window.safeAreaInsets
        }
        return .zero
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController),
              selectedIndex == 1 else {
            return true
        }
        let registerViewController = RegisterViewController()
        registerViewController.modalTransitionStyle = .coverVertical
        registerViewController.modalPresentationStyle = .fullScreen
        tabBarController.selectedViewController?.show(registerViewController, sender: nil)
        return false
    }
}
