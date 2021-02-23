//
//  HomeCollectionViewCell.swift
//  DailyYamazaki
//
//  Created by 重盛晴二 on 2021/02/20.
//

import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    static let identifier = "HomeCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    public func configure(with imageStr: String, text: String) {
//        urlからimageに変える
        let imageURL = URL(string: imageStr)
        
        imageView.sd_setImage(with: imageURL)
        imageView.contentMode = .scaleToFill
        
        label.text = text
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HomeCollectionViewCell", bundle: nil)
    }
}
