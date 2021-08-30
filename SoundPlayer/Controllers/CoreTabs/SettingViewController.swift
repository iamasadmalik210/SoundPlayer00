//
//  SettingViewController.swift
//  SoundPlayer
//
//  Created by Asad on 03/08/2021.
//

import UIKit

class SettingViewController: UIViewController {
    
    
    var timerValues = ["1 Minutes","2 Minutes","30 Minutes","60 Minutes","Unlimited"]
    
    var volumePercentage = ["Mute","25%","50%","75%","Loud"]
    
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        
        //        tableView.register(SoundsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.backgroundColor = .black
        return tableView
        
        
        
    }()
    private var sections = [Section]()
    
    
    
    private func configurableModels(){
        
        sections.append(Section(title: "Profile", options: [Option(title: "View Your Profile", handler:{ [weak self] in
            DispatchQueue.main.async {
                
                self?.viewProfile()
            }
        })]))
        
        sections.append(Section(title: "Sound Settings", options: [Option(title: "Timer", handler:{ [weak self] in
            DispatchQueue.main.async {
                
                guard let timerValue = self?.timerValues else{
                    print("timer value error")
                    
                    return
                }
                
                
                let vc = SoundSettingViewController()
                
                
                vc.pickerViewData = timerValue
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }
        }),Option(title: "Adjust Volume", handler: {
            DispatchQueue.main.async {
                //                guard let volume = self.volumePercentage else {
                //                                print("Volume value error")
                //
                //                                return
                //                            }
                
                
                let vc = SoundSettingViewController()
                vc.pickerViewData = self.volumePercentage
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
        }),Option(title: "View Timer", handler: {
            
        })]))
        
    }
    
    
    private func signOutTapped() {
        
        print("signout tappped")
        //
        //        let alert = UIAlertController(title: "Sign out", message: "Are you sure?", preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //        alert.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: { _ in
        //
        //            AuthManager.shared.singOut { [weak self] signedOut in
        //
        //                if signedOut {
        //                    DispatchQueue.main.async {
        //
        //
        //
        //                        let navVC = UINavigationController(rootViewController:WelcomeViewController())
        //
        //                        navVC.navigationBar.prefersLargeTitles = true
        //                        navVC.navigationController?.navigationItem.largeTitleDisplayMode = .always
        //                        navVC.modalPresentationStyle = .fullScreen
        //                        self?.present(navVC, animated: true, completion: {
        //
        //                        })
        //        }
        //
        //                }
        //
        //            }
        //
        //        }))
        //        present(alert, animated: true, completion: nil)
        //
        //
        
        
    }
    
    private func viewProfile(){
        
        //        let vc = ProfileViewController()
        //        vc.title = "Profile"
        //        vc.navigationItem.largeTitleDisplayMode = .never
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .systemBackground
        
        configurableModels()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
}
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = sections[indexPath.section] .options[indexPath.row]
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = model.title
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].options.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        call for handler in the table viewcell
        let model = sections[indexPath.section].options[indexPath.row]
        
        model.handler()
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //        let model = sections[indexPath.section].options[indexPath.row]
        let model = sections[section]
        return model.title
    }
    
}
