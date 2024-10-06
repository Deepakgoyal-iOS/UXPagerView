//
//  UXPageTabCollectionViewCell.swift
//  Powerplay
//
//  Created by Deepak Goyal on 05/04/23.
//

import UIKit

class UXPageTabCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var badgeCountLbl: UILabel!
    @IBOutlet weak var badgeCountContainer: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var sideSeparatorView: UIView!
    static let id = "UXPageTabCollectionViewCell"
    static let cellHeight = 42.0
    static let widthInsetExcludingTitle = 50.0
    static let widthInsetExcludingTitleAndBadge = 32.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.setupUI()
        }
    }
    
    private func setupUI(){
        
        titleLbl.font = .systemFont(ofSize: 14)
        badgeCountLbl.font = .systemFont(ofSize: 12)
        badgeCountLbl.textColor = .white
        badgeCountLbl.backgroundColor = UIColor(red: 196/255.0, green: 34/255.0, blue: 25/255.0, alpha: 1)
        badgeCountLbl.layer.cornerRadius = 9
        badgeCountLbl.layer.masksToBounds = true
        badgeCountLbl.adjustsFontSizeToFitWidth = true
        sideSeparatorView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1)
        separatorView.layer.cornerRadius = 1
        separatorView.layer.masksToBounds = true
        sideSeparatorView.layer.cornerRadius = 1
        separatorView.layer.masksToBounds = true

    }
    
    func setTitleLbl(_ text: String?){
        titleLbl.text = text
    }

    func setBadgeCountLbl(_ text: Int?){
        badgeCountContainer.isHidden = (text ?? 0) == 0
        badgeCountLbl.text = "\(text ?? 0)"
    }
    
    func setSelected(_ isSelected: Bool){
        self.separatorView.backgroundColor = isSelected ? .systemBlue : UIColor(red: 242/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1)
        titleLbl.font = isSelected ? .systemFont(ofSize: 14, weight: .semibold) : .systemFont(ofSize: 14)
        titleLbl.textColor = isSelected ? .systemBlue : .black
    }


}
