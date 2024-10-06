//
//  UXPageBaseViewControllerProtocol.swift
//  Powerplay
//
//  Created by Deepak Goyal on 02/04/23.
//

import UIKit

@MainActor
protocol UXPageBaseViewControllerProtocol{
    
    func getTabTitle() -> String
    func getTabBadgeCount() -> Int
    func getTab(_ collectionView: UICollectionView, indexPath: IndexPath, isSelected: Bool) -> UICollectionViewCell?
    func getTabCellIdentifier() -> String
    
}
extension UXPageBaseViewControllerProtocol where Self: UIViewController{
    
    func getTab(_ collectionView: UICollectionView, indexPath: IndexPath, isSelected: Bool) -> UICollectionViewCell?{
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getTabCellIdentifier(), for: indexPath) as? UXPageTabCollectionViewCell else {
           return UICollectionViewCell()
        }
        cell.setTitleLbl(getTabTitle())
        cell.setBadgeCountLbl(getTabBadgeCount())
        cell.setSelected(isSelected)
        return cell
    }
    
    func getTabCellIdentifier() -> String{
        return UXPageTabCollectionViewCell.id
    }
}
