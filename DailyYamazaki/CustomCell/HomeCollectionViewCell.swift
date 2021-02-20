//
//  HomeCollectionViewCell.swift
//  DailyYamazaki
//
//  Created by 重盛晴二 on 2021/02/20.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!

    @IBOutlet weak var label: UILabel!
    
    static let identifier = "HomeCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    public func configure(with image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleToFill
        
        label.text = "aa"
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HomeCollectionViewCell", bundle: nil)
    }
}
