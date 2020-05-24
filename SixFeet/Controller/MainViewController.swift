//
//  ViewController.swift
//  SixFeet
//
//  Created by Alexander Englander on 4/23/20.
//  Copyright © 2020 Alexander Englander. All rights reserved.
//

import UIKit
import ARKit
import AVFoundation

class MainViewController: UIViewController, ARSCNViewDelegate, InfoViewControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var distanceTextField: UITextField!
    
    private var textTimer:Timer?
    
    
    private var trackerModel = TrackerModel(isMetric: false)
    
    private var player:AVAudioPlayer?
    private var makeSound:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If we've gotten to this point, we've done the onboarding
        if UserDefaults.standard.bool(forKey: "Onboarding") == false {
            UserDefaults.standard.set(true, forKey: "Onboarding")
            // By default, enable sounds
            UserDefaults.standard.set(true, forKey: "makeSound")
        }
        
        if UserDefaults.standard.bool(forKey: "makeSound") {
            self.makeSound = true
        } else {
            self.makeSound = false
        }
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Don't dim display
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // unit system
        if let unitSystem = UserDefaults.standard.string(forKey: "unitSystem") {
            self.trackerModel.updateUnits(unitSystem: unitSystem)
            self.distanceTextField.text = "-- \(self.trackerModel.getDistanceUnits())"
        }
    }
    
    // MARK: - overriding view methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        guard ARBodyTrackingConfiguration.isSupported else {
            // This should have been checked earlier in OnboardViewController
            // Just goint to return here...
            return
        }
        let configuration = ARBodyTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        configuration.automaticSkeletonScaleEstimationEnabled = true
        configuration.frameSemantics.insert(.bodyDetection)
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - Segue
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo" {
            let destinationVC = segue.destination as! InfoViewController
            destinationVC.delegate = self
        }
    }
    
    // MARK: - Timer
    @objc func skeletonLost(_ sender:Timer){
        self.stopAlarm(self.player)
        self.distanceTextField.textColor = UIColor.label
        self.distanceTextField.text = "-- \(self.trackerModel.getDistanceUnits())"
        
    }
    
    // MARK: - ARKit node update
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode,for anchor: ARAnchor) {
        if let bodyAnchor = anchor as? ARBodyAnchor {
            // Timer that resets distance text if nothing is currently detected
            DispatchQueue.main.async {
                if(self.textTimer != nil){
                    self.textTimer!.invalidate()
                }
                self.textTimer = Timer.scheduledTimer(timeInterval: 0.6 , target: self, selector: #selector(self.skeletonLost(_:)), userInfo: nil, repeats: false)
            }
            if let transform = bodyAnchor.skeleton.jointLocalTransforms.first, let cameraNode = sceneView.session.currentFrame?.camera {
                let skeletonPosition = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                var distanceString = self.trackerModel.getDistanceString(nodeUpdate: node, cameraNode: cameraNode)
                let cylinderNode = self.trackerModel.getCylinderNode(vector3: skeletonPosition)
                distanceString += self.trackerModel.getDistanceUnits()
                node.addChildNode(cylinderNode)
                
                // change label text to update distance
                DispatchQueue.main.async { [weak self] in
                    self?.distanceTextField.text = distanceString
                    if let distance = self?.trackerModel.getDistance(), let distanceBoundary = self?.trackerModel.getDistanceBoundary(), let soundAlarm = self?.makeSound {
                        if distance < distanceBoundary {
                            self?.distanceTextField.textColor = UIColor.systemRed
                            if soundAlarm {
                                if let alarm = self?.player {
                                    if !alarm.isPlaying {
                                        self?.playAlarm()
                                    }
                                } else {
                                    self?.playAlarm()
                                }
                            }
                        } else {
                            self?.distanceTextField.textColor = UIColor.systemGreen
                            self?.stopAlarm(self?.player)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Sounds
    func playAlarm() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            //category .ambient if want to silence sound when in silent mode...
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

            guard let player = player else { return }
            player.numberOfLoops = -1
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopAlarm(_ inPlayer:AVAudioPlayer?) {
        if let alarm = inPlayer {
            if alarm.isPlaying {
                alarm.stop()
            }
        }
    }
    
    // MARK: - InfoView Delegate
    func didUpdateUnits (_ unitSystem: String) {
        self.trackerModel.updateUnits(unitSystem: unitSystem)
        self.distanceTextField.text = "-- \(self.trackerModel.getDistanceUnits())"
    }
    
    func didUpdateSoundPreferences(_ makeSound: Bool) {
        if makeSound {
            self.makeSound = true
        } else {
            self.makeSound = false
        }
    }
}
