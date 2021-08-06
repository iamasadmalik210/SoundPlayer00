//
//  SoundSettingViewController.swift
//  SoundPlayer
//
//  Created by Asad on 04/08/2021.
//

import UIKit

class SoundSettingViewController: UIViewController {
    
    
    var pickerViewData = [String]()
    
    public let pickerView : UIPickerView = {
       let picker = UIPickerView()
    
        
        return picker
        
        
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pickerView.center = view.center
    }
   

}


extension SoundSettingViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerViewData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print(pickerViewData[row])
        
        
        let timer = pickerViewData[row]
        UserDefaults.standard.setValue(timer, forKeyPath: "timer_value")
    }
    
    
    
    
    
    
}
