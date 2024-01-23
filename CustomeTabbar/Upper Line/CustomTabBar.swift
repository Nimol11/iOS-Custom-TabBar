//
//  CustomTabBar.swift
//  CustomTabbar
//
//  Created by Nimol on 23/1/24.
//

import UIKit

class CustomTabBar: UITabBarController, UITabBarControllerDelegate {

    var upperLineView: UIView!
    
    let spacing: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            self.addTabBarIndicatorView(index: 0, isFirstTime: true)
        }
    }
    
    func addTabBarIndicatorView(index: Int, isFirstTime: Bool = false){
        guard let tabView = tabBar.items?[index].value(forKey: "view") as? UIView else {
            return
        }
        if !isFirstTime{
            upperLineView.removeFromSuperview()
        }
        upperLineView = UIView(frame: CGRect(x: tabView.frame.minX + spacing, y: tabView.frame.minY - 2 , width: tabView.frame.size.width - spacing * 2, height: 3))
        upperLineView.backgroundColor = UIColor.purple
        tabBar.addSubview(upperLineView)
    }
  
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        addTabBarIndicatorView(index: self.selectedIndex)
    }
    
}

