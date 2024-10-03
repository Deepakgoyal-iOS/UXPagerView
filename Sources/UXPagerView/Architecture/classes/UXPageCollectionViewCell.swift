//
//  UXPageCollectionViewCell.swift
//  Powerplay
//
//  Created by Deepak Goyal on 03/04/23.
//

import UIKit

class UXPageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vcContainer: UIView!
    static let id = "UXPageCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setViewController(_ viewController: UIViewController?, cachedControllers: [Int: UIViewController]){
        
        vcContainer.subviews.forEach({ $0.removeFromSuperview() })

        //Just for loading view
        cachedControllers.forEach({ key, value in
            let _ = value.view
        })
        
        if let viewController = viewController{
            
            vcContainer.addSubview(viewController.view)
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            viewController.view.topAnchor.constraint(equalTo: vcContainer.topAnchor).isActive = true
            viewController.view.bottomAnchor.constraint(equalTo: vcContainer.bottomAnchor).isActive = true
            viewController.view.leadingAnchor.constraint(equalTo: vcContainer.leadingAnchor).isActive = true
            viewController.view.trailingAnchor.constraint(equalTo: vcContainer.trailingAnchor).isActive = true
           
        }
    }
    
}
