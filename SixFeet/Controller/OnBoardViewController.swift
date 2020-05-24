//
//  OnboardViewController.swift
//  SixFeet
//
//  Created by Alexander Englander on 5/9/20.
//  Copyright © 2020 Alexander Englander. All rights reserved.
//

import UIKit
import ARKit

class OnBoardViewController: UIViewController, UIScrollViewDelegate, OnBoardViewProtocol {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var uhohTitle: UILabel!
    @IBOutlet weak var uhohSubtitle: UILabel!
    
    private var scrollWidth: CGFloat! = 0.0
    private var scrollHeight: CGFloat! = 0.0
    private var numSlides:Int = 5
    
    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        if ARBodyTrackingConfiguration.isSupported {
            uhohTitle.isHidden = true
            uhohSubtitle.isHidden = true
            pageControl.currentPageIndicatorTintColor = UIColor.label
            pageControl.pageIndicatorTintColor = UIColor.systemGray
            
            self.scrollView.delegate = self
            scrollView.isPagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            
            var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            
            for index in 0..<numSlides {
                frame.origin.x = scrollWidth * CGFloat(index)
                frame.size = CGSize(width: scrollWidth, height: scrollHeight)
                let slide = OnBoardView(frame: frame)
                switch index {
                case 0:
                    slide.title01.isHidden = false
                    slide.title02.isHidden = true
                    slide.title03.isHidden = true
                    slide.title04.isHidden = true
                    slide.title05.isHidden = true
                    slide.subtitle01.isHidden = false
                    slide.subtitle02.isHidden = true
                    slide.subtitle03.isHidden = true
                    slide.subtitle04.isHidden = true
                    slide.distanceLabel.backgroundColor = UIColor.systemGray
                    slide.infoButton.tintColor = UIColor.systemGray
                    slide.useAppButton.isHidden = true
                case 1:
                    slide.title01.isHidden = true
                    slide.title02.isHidden = false
                    slide.title03.isHidden = true
                    slide.title04.isHidden = true
                    slide.title05.isHidden = true
                    slide.subtitle01.isHidden = true
                    slide.subtitle02.isHidden = false
                    slide.subtitle03.isHidden = true
                    slide.subtitle04.isHidden = true
                    slide.distanceLabel.backgroundColor = UIColor.systemGray
                    slide.infoButton.tintColor = UIColor.systemGray
                    slide.useAppButton.isHidden = true
                case 2:
                    slide.title01.isHidden = true
                    slide.title02.isHidden = true
                    slide.title03.isHidden = false
                    slide.title04.isHidden = true
                    slide.title05.isHidden = true
                    slide.subtitle01.isHidden = true
                    slide.subtitle02.isHidden = true
                    slide.subtitle03.isHidden = false
                    slide.subtitle04.isHidden = true
                    slide.distanceLabel.backgroundColor = UIColor.white
                    slide.infoButton.tintColor = UIColor.systemGray
                    slide.useAppButton.isHidden = true
                case 3:
                    slide.title01.isHidden = true
                    slide.title02.isHidden = true
                    slide.title03.isHidden = true
                    slide.title04.isHidden = false
                    slide.title05.isHidden = true
                    slide.subtitle01.isHidden = true
                    slide.subtitle02.isHidden = true
                    slide.subtitle03.isHidden = true
                    slide.subtitle04.isHidden = false
                    slide.distanceLabel.backgroundColor = UIColor.systemGray
                    slide.infoButton.tintColor = UIColor.white
                    slide.useAppButton.isHidden = true
                case 4:
                    slide.title01.isHidden = true
                    slide.title02.isHidden = true
                    slide.title03.isHidden = true
                    slide.title04.isHidden = true
                    slide.title05.isHidden = false
                    slide.subtitle01.isHidden = true
                    slide.subtitle02.isHidden = true
                    slide.subtitle03.isHidden = true
                    slide.subtitle04.isHidden = true
                    slide.distanceLabel.backgroundColor = UIColor.systemGray
                    slide.infoButton.tintColor = UIColor.systemGray
                    slide.useAppButton.isHidden = false
                    slide.delegate = self
                default:
                    break
                }
                scrollView.addSubview(slide)
            }
            
            scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(numSlides), height: scrollHeight)
            self.scrollView.contentSize.height = 1.0
            pageControl.numberOfPages = numSlides
            pageControl.currentPage = 0
        } else {
            uhohTitle.isHidden = false
            uhohSubtitle.isHidden = false
            scrollView.isHidden = true
            pageControl.isHidden = true
        }
        

    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        if let scrollPane = self.scrollView, let pageController = self.pageControl {
            scrollPane.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat(pageController.currentPage), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndicatorForCurrentPage()
    }

    func setIndicatorForCurrentPage()  {
        if let scrollPane = self.scrollView, let pageController = self.pageControl {
            let page = scrollPane.contentOffset.x/scrollWidth
            pageController.currentPage = Int(page)
        }
        
    }
    
    func startButtonTapped() {
        self.performSegue(withIdentifier: "showMain", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
}
