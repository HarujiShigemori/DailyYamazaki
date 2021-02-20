
//横スクロールの画像を増減させたい場合
//最初の方のimagesDataの中を変更するだけ
//Assets.xcassetsの中に画像ファイルを入れとく

import UIKit
import SDWebImage

class HomeViewController: UIViewController,GetDataProtocol {
    
    var topImageUrlArray = [String]()
    
//    別のファイルから配列の情報を持ってくる
    func topImageUrlGetData(dataArray: [String]) {
        topImageUrlArray = dataArray
//        配列の個数が決まったので、scrollViewの表示を決めるメソッド実行
        configureScrollView()
//        pageControlの丸の数
        pageControl.numberOfPages = topImageUrlArray.count
        
    }
    
//    scrollViewとpageControlの配置のためのcontentView
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    
    var homeTopLoadImage = HomeTopLoadImage()
    private let sideScrollView = UIScrollView()
    
    
    let pageControl: UIPageControl = {
        
        let pageControl = UIPageControl()
        
        UIPageControl.appearance().pageIndicatorTintColor = .rgb(red: 50, green: 50, blue: 50)
        UIPageControl.appearance().currentPageIndicatorTintColor = .rgb(red: 220, green: 50, blue: 35)
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        pageControl.isEnabled = false
        
        return pageControl
    }()
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        sideScrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width - 60, y: 0), animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTopLoadImage.getDataProtocol = self
//        スクロールのバウンドさせない
        verticalScrollView.bounces = false
        sideScrollView.delegate = self
        
        contentView.addSubview(pageControl)
        contentView.addSubview(sideScrollView)
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.register(HomeCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)

        homeCollectionLayout()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeTopLoadImage.loadTopImage()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pageControl.frame = CGRect(x: 30, y: 170, width: view.frame.size.width - 60, height: 30)
        sideScrollView.frame = CGRect(x: 30, y: 10, width: view.frame.size.width - 60, height: 150)
        
    }
    
//    横スクロールの画像表示
    private func configureScrollView() {
//        イメージの大きさ
        sideScrollView.contentSize = CGSize(width: (view.frame.size.width - 60) * CGFloat(topImageUrlArray.count), height: sideScrollView.frame.size.height)
        sideScrollView.isPagingEnabled = true
//        画像の数だけsideScrollViewが横に伸びる
        for x in 0..<topImageUrlArray.count {
            let page = UIImageView(frame: CGRect(x: CGFloat(x) * sideScrollView.frame.size.width, y: 0, width: sideScrollView.frame.size.width, height: sideScrollView.frame.size.height))
//            urlからimageに変換
            let imageURL = URL(string: topImageUrlArray[x])
            page.sd_setImage(with: imageURL)

//            let imageData:UIImage = UIImage(data: topImageUrlArray[x])!
            page.contentMode = .scaleToFill
            sideScrollView.addSubview(page)
        }
    }

}

//
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floor(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}

extension HomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeCollectionView.deselectItem(at: indexPath, animated: true)
        
        print("tapped")
    }
}

extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        
        cell.configure(with: UIImage(named: "ice31")!)
        
        return cell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    

    func homeCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        //        行間
        layout.minimumLineSpacing = 15
        //        セクションの余白（labelからの長さ）
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        homeCollectionView.collectionViewLayout = layout
        //        スクロールさせない
        homeCollectionView.isScrollEnabled = false
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        
        return CGSize(width: homeCollectionView.frame.width / 3 * 1.4, height: homeCollectionView.frame.height / 6)
    }
}


