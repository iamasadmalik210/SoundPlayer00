//
//  CustomViewController.swift
//  SoundPlayer
//
//  Created by Asad on 03/08/2021.
//

import UIKit

class CustomViewController: UIViewController {
    var viewModels = [CustomModel(image: UIImage(systemName:"cloud.rain"), title: "Rain"),CustomModel(image: UIImage(systemName:"cloud.rain"), title: "Rain"),CustomModel(image: UIImage(systemName:"cloud.rain"), title: "Rain"),CustomModel(image: UIImage(systemName:"cloud.rain"), title: "Rain"),CustomModel(image: UIImage(systemName:"cloud.rain"), title: "Rain"),]
    
    
    
    
    let searchView = SearchView()
    
    private let collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.register(SearchView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.backgroundColor = . systemBackground
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
//        view.addSubview(searchView)
        
        navigationController?.isNavigationBarHidden  = true

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 50)
        collectionView.frame = CGRect(x: 5, y: searchView.bottom, width: view.width - 10, height:view.height - searchView.height)
        
    }
    

}
extension CustomViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionViewCell else{
            fatalError()
        }
        cell.configure(viewModels: viewModels[indexPath.row])
        cell.backgroundColor = .darkGray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let height = view.frame.size.height
            let width = view.frame.size.width
            // in case you you want the cell to be 40% of your controllers view
            return CGSize(width: width * 0.43, height: height * 0.3)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlayerViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
  
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "headerView", for: indexPath)
//        headerView.frame.size.height = 50
//
//        return headerView
//    }
    
}
