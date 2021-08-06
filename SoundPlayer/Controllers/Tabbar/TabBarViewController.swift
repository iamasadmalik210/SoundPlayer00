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

