//
//  ViewController.swift
//  SoundPlayer
//
//  Created by Asad on 03/08/2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .gray
        
        setUpControllers()
    }

    
    private func setUpControllers(){
        
        let sound = SoundViewController()
        sound.title = "Sounds"
        let custom = CustomViewController()
        custom.title = "Customs"
        
        let setting = SettingViewController()
        setting.title = "Settings"
        
        sound.navigationItem.largeTitleDisplayMode = .always
        custom.navigationItem.largeTitleDisplayMode = .always
        
        
        let nav1 = UINavigationController(rootViewController: sound)
        
        let nav2 = UINavigationController(rootViewController: custom)
        
        
        let nav3 = UINavigationController(rootViewController: setting)

        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles  = true
        nav3.navigationBar.prefersLargeTitles = true

        nav1.tabBarItem = UITabBarItem(title: "Sounds", image: UIImage(systemName: "waveform"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Custom", image: UIImage(systemName: "slider.horizontal.3"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 3)

        setViewControllers([nav1,nav2,nav3], animated: true)

        
    }
    

}




extension UIView {
    var width: CGFloat {
        return frame.size.width
    }

    var height: CGFloat {
        return frame.size.height
    }

    var left: CGFloat {
        return frame.origin.x
    }

    var right: CGFloat {
        return left + width
    }

    var top: CGFloat {
        return frame.origin.y
    }

    var bottom: CGFloat {
        return top + height
    }
}

/*
 
 
 var currentlyPlaying: CurrentlyPlayingView!
    static let maxHeight = 100
    static let minHeight = 49
    static var tabbarHeight = maxHeight

    override func viewDidLoad() {
        super.viewDidLoad()

        currentlyPlaying = CurrentlyPlayingView(copyFrom: tabBar)
        currentlyPlaying.tabBar.delegate = self

        view.addSubview(currentlyPlaying)
        tabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        currentlyPlaying.tabBar.items = tabBar.items
        currentlyPlaying.tabBar.selectedItem = tabBar.selectedItem
    }
    func hideCurrentlyPlaying() {
        TabBarViewController.tabbarHeight = TabBarViewController.minHeight
        UIView.animate(withDuration: 0.5, animations: {
            self.currentlyPlaying.hideCustomView()
            self.updateSelectedViewControllerLayout()
        })
    }
    func updateSelectedViewControllerLayout() {
        tabBar.sizeToFit()
        tabBar.sizeToFit()
        currentlyPlaying.sizeToFit()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        viewControllers?[self.selectedIndex].view.setNeedsLayout()
        viewControllers?[self.selectedIndex].view.layoutIfNeeded()
    }
}

extension UITabBar {

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = CGFloat(TabBarViewController.tabbarHeight)
        return sizeThatFits
    }
}
 */
