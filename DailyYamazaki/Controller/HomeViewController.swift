
//横スクロールの画像を増減させたい場合
//最初の方のimagesDataの中を変更するだけ
//Assets.xcassetsの中に画像ファイルを入れとく

import UIKit
import SDWebImage

class HomeViewController: UIViewController,GetTopDataProtocol,GetHomeDataProtocol{
    
    
    var topImageUrlArray = [String]()
    var homeImageUrlArray = ["https://firebasestorage.googleapis.com/v0/b/dailyapp-d02cb.appspot.com/o/home%2FNoImage.png?alt=media&token=2db5402a-f6ac-49a1-a074-9ea3f9cebb91"]
    var homeTextArray = ["text"]
    
//    別のファイルから配列の情報を持ってくる
    func topImageUrlGetData(dataArray: [String]) {
        topImageUrlArray = dataArray
//        配列の個数が決まったので、scrollViewの表示を決めるメソッド実行
        configureScrollView()
        pageControl.numberOfPages = topImageUrlArray.count
        
    }
    func homeGetData(urlDataArray: [String], textDataArray: [String]) {
        homeImageUrlArray = []
        homeTextArray = []
        
        homeImageUrlArray = urlDataArray
        homeTextArray = textDataArray
        
        homeCollectionView.reloadData()
    }
    
//    scrollViewとpageControlの配置のためのcontentView
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    
    var loadData = LoadData()
    private let sideScrollView = UIScrollView()
    
    
    let pageControl: UIPageControl = {
        
        let pageControl = UIPageControl()
        
        UIPageControl.appearance().pageIndicatorTintColor = .rgb(red: 50, green: 50, blue: 50)
        UIPageControl.appearance().currentPageIndicatorTintColor = .rgb(red: 220, green: 50, blue: 35)
//調べる
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
        
        loadData.getTopDataProtocol = self
        loadData.getHomeDataProtocol = self
//        スクロールのバウンドさせない
        verticalScrollView.bounces = false
        verticalScrollView.showsVerticalScrollIndicator = false
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
//       LoadDataModelの関数を呼ぶ
        loadData.loadTopImage()
        loadData.loadHomeImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topSize()
        
    }
//    ホームのトップの画像のサイズを端末の横幅によって決める
    func topSize() {
        
        if view.frame.size.width >= 500 {
            pageControl.frame = CGRect(x: 100, y: view.frame.size.height / 6 + 10, width: view.frame.size.width - 200, height: 30)
            sideScrollView.frame = CGRect(x: 100, y: 10, width: view.frame.size.width - 200, height: view.frame.size.height / 6)
        }else{
            pageControl.frame = CGRect(x: 30, y: 170, width: view.frame.size.width - 60, height: 30)
            sideScrollView.frame = CGRect(x: 30, y: 10, width: view.frame.size.width - 60, height: view.frame.size.height / 6)
        }

    }
    
//    横スクロールの画像表示
    private func configureScrollView() {
//        イメージの大きさ
        sideScrollView.contentSize = CGSize(width: sideScrollView.frame.size.width * CGFloat(topImageUrlArray.count), height: sideScrollView.frame.size.height)
        sideScrollView.isPagingEnabled = true
        sideScrollView.showsHorizontalScrollIndicator = false
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

//ここから下はUICollectionView
extension HomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeCollectionView.deselectItem(at: indexPath, animated: true)
        print("tapped")
    }
}

extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeImageUrlArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        
        let imageUrl = homeImageUrlArray[indexPath.row]
        let text = homeTextArray[indexPath.row]
//        カスタムセルファイルに送って返してもらう
        cell.configure(with: imageUrl, text: text)
        
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    
    func homeCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 15
        //        セクションの余白（labelからの長さ）
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        homeCollectionView.collectionViewLayout = layout
        homeCollectionView.isScrollEnabled = false
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: homeCollectionView.frame.width / 3 * 1.4, height: homeCollectionView.frame.height / 6)
    }
}


