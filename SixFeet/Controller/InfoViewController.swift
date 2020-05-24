//
//  InfoViewController.swift
//  SixFeet
//
//  Created by Alexander Englander on 4/27/20.
//  Copyright © 2020 Alexander Englander. All rights reserved.
//

import UIKit
import SafariServices

protocol InfoViewControllerDelegate {
    func didUpdateUnits(_ unitSystem: String)
    func didUpdateSoundPreferences(_ makeSound: Bool)
}

class InfoViewController: UIViewController {
    
    @IBOutlet weak var selectedUnits: UISegmentedControl!
    @IBOutlet weak var soundSwitch: UISwitch!
    var delegate: InfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "makeSound") == true {
            soundSwitch.isOn = true
        } else {
            soundSwitch.isOn = false
        }
        
        //set units
        if let unitSystem = UserDefaults.standard.string(forKey: "unitSystem") {
            if unitSystem == "Imperial" {
                selectedUnits.selectedSegmentIndex = 0
            } else {
                selectedUnits.selectedSegmentIndex = 1
            }
        }
    }
    
    @IBAction func tappedXMarkButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changedSelectedUnits(_ sender: UISegmentedControl) {
        if let unitSystem = sender.titleForSegment(at: sender.selectedSegmentIndex) {
            UserDefaults.standard.set(unitSystem, forKey: "unitSystem")
            self.delegate?.didUpdateUnits(unitSystem)
        }
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "makeSound")
            self.delegate?.didUpdateSoundPreferences(true)
        } else {
            UserDefaults.standard.set(false, forKey: "makeSound")
            self.delegate?.didUpdateSoundPreferences(false)
        }
    }
    
    @IBAction func tappedViewPrivacyPolicy(_ sender: UIButton) {
        #warning("add your privacy policy here---v") // TODO
        guard let url =  URL(string: "https://google.com") else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
}
