
//横スクロールの画像を増減させたい場合
//最初の方のimagesDataの中を変更するだけ
//Assets.xcassetsの中に画像ファイルを入れとく

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    let imagesData = [
        "ocha2",
        "hinamaturi",
        "panmaturi",
        "ice31",
        "rakutenPoint"
    ]
    
    private let sideScrollView = UIScrollView()
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.backgroundColor = .systemYellow
        return pageControl
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageControl)
        view.addSubview(sideScrollView)
//        ちょっと不安
        pageControl.numberOfPages = imagesData.count
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageControl.frame = CGRect(x: 30, y: 300, width: view.frame.size.width - 60, height: 30)
        sideScrollView.frame = CGRect(x: 30, y: 120, width: view.frame.size.width - 60, height: 150)
        configureScrollView()
    }
    
    
//    横スクロールの画像表示
    private func configureScrollView() {
//        イメージの大きさ
        sideScrollView.contentSize = CGSize(width: (view.frame.size.width - 60) * CGFloat(imagesData.count), height: sideScrollView.frame.size.height)
        sideScrollView.isPagingEnabled = true
//        画像の数だけsideScrollViewが横に伸びる
        for x in 0..<imagesData.count {
            let page = UIImageView(frame: CGRect(x: CGFloat(x) * sideScrollView.frame.size.width, y: 0, width: sideScrollView.frame.size.width, height: sideScrollView.frame.size.height))
//            stringからimageに変換
            let imageData:UIImage = UIImage(named: imagesData[x])!
            page.image = imageData
//            page.contentMode = .scaleToFill
            sideScrollView.addSubview(page)
        }
    }


}

