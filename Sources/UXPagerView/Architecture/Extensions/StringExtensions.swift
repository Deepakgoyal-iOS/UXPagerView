//
//  StringExtensions.swift
//  UXPagerView
//
//  Created by Deepak Goyal on 05/08/23.
//

import UIKit

@MainActor
extension String{
    
    func width(for font: UIFont?, numberOfLines: Int = 1) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byWordWrapping
        label.font = font ?? .systemFont(ofSize: 14)
        label.text = self
        label.sizeToFit()
        return label.bounds.width
    }
    
}
