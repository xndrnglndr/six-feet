//
//  OnBoardView.swift
//  SixFeet
//
//  Created by Alexander Englander on 5/9/20.
//  Copyright © 2020 Alexander Englander. All rights reserved.
//

import UIKit

protocol OnBoardViewProtocol {
    func startButtonTapped()
}

class OnBoardView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var distanceLabel: UITextField!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var title01: UILabel!
    @IBOutlet weak var subtitle01: UILabel!
    @IBOutlet weak var title02: UILabel!
    @IBOutlet weak var subtitle02: UILabel!
    @IBOutlet weak var title03: UILabel!
    @IBOutlet weak var subtitle03: UILabel!
    @IBOutlet weak var title04: UILabel!
    @IBOutlet weak var subtitle04: UILabel!
    @IBOutlet weak var title05: UILabel!
    @IBOutlet weak var infoButtonBgView: UIView!
    @IBOutlet weak var useAppButton: UIButton!
    var delegate: OnBoardViewProtocol? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed("OnboardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        useAppButton.layer.cornerRadius = 10
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        self.delegate?.startButtonTapped()
    }
    
}
