//
//  HomeViewController.swift
//  DailyYamazaki
//
//  Created by 重盛晴二 on 2021/02/11.
//

//横スクロールの画像の数を変更したい場合はSideViewの
//AutoLayoutのwidthを変える。
//imageviewの間20,width360

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    private let sideScrollView = UIScrollView()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        pageControl.backgroundColor = .systemYellow
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageControl)
        view.addSubview(sideScrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageControl.frame = CGRect(x: 30, y: 300, width: view.frame.size.width - 60, height: 30)
        sideScrollView.frame = CGRect(x: 30, y: 120, width: view.frame.size.width - 60, height: 150)
        configureScrollView()
    }
    
    
//    横スクロールの画像表示
    private func configureScrollView() {
        
        let imagesData = [
            "ocha2",
            "hinamaturi",
            "panmaturi",
            "ice31",
            "rakutenPoint"
        ]
        sideScrollView.contentSize = CGSize(width: (view.frame.size.width - 60) * 5, height: sideScrollView.frame.size.height)
        sideScrollView.isPagingEnabled = true
        
        for x in 0..<5 {
            let page = UIImageView(frame: CGRect(x: CGFloat(x) * sideScrollView.frame.size.width, y: 0, width: sideScrollView.frame.size.width, height: sideScrollView.frame.size.height))
            let imageData:UIImage = UIImage(named: imagesData[x])!
            
            page.image = imageData
            page.contentMode = .scaleToFill
            sideScrollView.addSubview(page)
        }
    }


}

