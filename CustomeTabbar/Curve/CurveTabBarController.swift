//
//  CurveTabBarController.swift
//  CustomeTabbar
//
//  Created by Nimol on 23/1/24.
//

import UIKit

class CurveTabBarController: UITabBarController {

    private var circleView: UIView!
    private var circleImageView: UIImageView!
    override var selectedViewController: UIViewController? {
        willSet {
            guard let newValue = newValue,
                  let tabBar = tabBar as? DesignCurveTabBar,
                  let index = viewControllers?.firstIndex(of: newValue) else { return }
            // MARK: Todo
            updateCirCle(index: index)
            tabBar.select(itemAt: index, animation: true)
        }
    }
    override var selectedIndex: Int {
        willSet {
            guard let tabBar = tabBar as? DesignCurveTabBar else { return }
            // MARK: Todo
            updateCirCle(index: newValue)
            tabBar.select(itemAt: newValue, animation: true)
        }
    }
    private var _barHeight: CGFloat = 74
    var barHeight: CGFloat {
        get {
            return _barHeight + view.safeAreaInsets.bottom
        }
        set {
            _barHeight = newValue
            updateTabBarFrame()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = DesignCurveTabBar()
        self.setValue(tabBar, forKey: "tabBar")
        addCircleView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        circleImageView.image = self.tabBar.selectedItem?.image ?? self.tabBar.items?.first?.image
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateTabBarFrame()
    }
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        updateTabBarFrame()
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        updateCirCle(index: index)
    }
  

}

extension CurveTabBarController {
    func updateCirCle(index: Int) {
        guard let items = tabBar.items,
              let vc = viewControllers,
              index < items.count,
              index < vc.count,
              index != selectedIndex else { return }
        let item = items[index]
        let controller = vc[index]
        
        let tabWidth = self.view.bounds.width / CGFloat(items.count)
        let circleWidth = self.circleView.bounds.width
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.circleView.frame = CGRect(
                x: (tabWidth * CGFloat(index) + tabWidth / 2 - circleWidth * 0.5),
                y: self.circleView.frame.minY,
                width: circleWidth,
                height: circleWidth)
        }
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let self = self else { return }
            self.circleImageView.alpha = 0
        }completion: { [weak self] _ in
            self?.circleImageView.image = item.image
            UIView.animate(withDuration: 0.15) { [weak self] in
                self?.circleImageView.alpha = 1
                
            }
        }
        delegate?.tabBarController?(self, didSelect: controller)
    }
    fileprivate func updateTabBarFrame() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = barHeight
        tabFrame.origin.y = self.view.frame.size.height - barHeight
        self.tabBar.frame = tabFrame
        tabBar.setNeedsLayout()
    }
    
    fileprivate func addCircleView() {
        let tabWidth = self.view.bounds.width / CGFloat(self.tabBar.items?.count ?? 4)
        let circleViewWidth = tabWidth * 0.5
        let circleViewRadius = circleViewWidth * 0.5
        
        self.circleView = UIView(frame: .zero)
        circleView.layer.cornerRadius = circleViewRadius
        circleView.backgroundColor = .white
        
        self.circleImageView = UIImageView(frame: .zero)
        circleImageView.layer.cornerRadius = circleViewRadius
        circleImageView.isUserInteractionEnabled = false
        circleImageView.contentMode = .center
        
        circleView.addSubview(circleImageView)
        self.view.addSubview(circleView)
        
        circleView.layer.shadowOffset = CGSize(width: 0, height: 0)
        circleView.layer.shadowRadius = 2
        circleView.layer.shadowColor = UIColor.black.cgColor
        circleView.layer.shadowOpacity = 0.15
        
        let bottomPadding = getBottomPadding()
        
        circleView.frame = CGRect(
            x: tabWidth / 2 - tabWidth * 0.25,
            y: self.tabBar.frame.origin.y - bottomPadding - circleViewWidth * 0.5,
            width: circleViewWidth,
            height: circleViewWidth)
        circleImageView.frame = self.circleView.bounds
    }
    fileprivate func getBottomPadding() -> CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            return window.safeAreaInsets.bottom
        } else {
            return view.safeAreaInsets.bottom
        }
        
    }
}
