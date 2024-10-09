//
//  UXPagerViewDelegate.swift
//  Powerplay
//
//  Created by Deepak Goyal on 05/04/23.
//

import UIKit

@MainActor
public protocol UXPagerViewDelegate: AnyObject{
    
    /// Total Number of tabs / pages `[Required]`
    /// - Parameter view: Pager View instance
    /// - Returns: Total count of tabs / pages
    func numberOfPages(_ view: UXPagerView) -> Int
    
    /// View Controller to show at given index `[Required]`
    /// - Parameters:
    ///   - view: Pager View instance
    ///   - index: Index of page / tab
    /// - Returns: View Controller to show at `index`
    func pagerView(_ view: UXPagerView, pageAtIndex index: Int) -> UIViewController?
    
    /// Title for tab to show at given index `[Required]`
    /// - Parameters:
    ///   - view: Pager View instance
    ///   - index: Index of page / tab
    /// - Returns: Title for tab at `index`
    func pagerView(_ view: UXPagerView, tabTitleAtIndex index: Int) -> String

    /// Count for badge on tab to show at given index.If badgeCount is '0' then badge is not visible.
    /// - Parameters:
    ///   - view: Pager View instance
    ///   - index: Index of page / tab
    /// - Returns: Count for badge on tab at `index`
    func pagerView(_ view: UXPagerView, tabBadgeAtIndex index: Int) -> Int
    
    /// Implement this method if need to show any custom tab cell UI.
    /// - Parameters:
    ///   - view: Pager View instance
    ///   - index: Index path of tab
    ///   - collectionView: Collection view present in tabs
    ///   - isSelected: Status if tab `index` is selected
    /// - Returns: Collection view cell UI need to be shown
    func pagerView(_ view: UXPagerView, cellForTabAtIndex index: IndexPath, collectionView: UICollectionView, isSelected: Bool) -> UICollectionViewCell?
    
    
    /// Identifier of custom collection view cells to register
    /// - Returns: Array of Identifiers
    func getTabCellIdentifiers() -> [String]
    
    
    /// Size for particular tab
    /// - Parameters:
    ///   - view: Pager View instance
    ///   - index: Index path of tab
    ///   - collectionView: Collection view present in tabs
    ///   - isSelected: Status if tab `index` is selected
    /// - Returns: Size of tab view cell
    func pagerView(_ view: UXPagerView, sizeForTabAtIndex index: IndexPath, collectionView: UICollectionView, isSelected: Bool) -> CGSize?
    
    
    /// Implement this method to get tab selection event
    /// - Parameters:
    ///   - view: Pager View instance
    ///   - index: Index path of tab
    func pagerView(_ view: UXPagerView, didSelectTabAt index: Int)

    /// Implement this method to get tab swipe event
    /// - Parameters:
    ///   - view: Pager View instance
    ///   - index: Index path of tab
    func pagerView(_ view: UXPagerView, didSwipeTabTo index: Int)
}
extension UXPagerViewDelegate{
    
    func pagerView(_ view: UXPagerView, cellForTabAtIndex index: IndexPath, collectionView: UICollectionView, isSelected: Bool) -> UICollectionViewCell?{
        
        return getTab(view, collectionView, indexPath: index, isSelected: isSelected)
    }
    
    func getTab(_ view: UXPagerView, _ collectionView: UICollectionView, indexPath: IndexPath, isSelected: Bool) -> UICollectionViewCell?{
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UXPageTabCollectionViewCell.id, for: indexPath) as? UXPageTabCollectionViewCell else {
           return UICollectionViewCell()
        }
        cell.setTitleLbl(pagerView(view, tabTitleAtIndex: indexPath.row))
        cell.setBadgeCountLbl(pagerView(view, tabBadgeAtIndex: indexPath.row))
        cell.setSelected(isSelected)
        return cell
    }
    
    func getTabCellIdentifiers() -> [String]{
        return [UXPageTabCollectionViewCell.id]
    }
    
    func pagerView(_ view: UXPagerView, sizeForTabAtIndex index: IndexPath, collectionView: UICollectionView, isSelected: Bool) -> CGSize?{
        return getDynamicCellSize(view, sizeForTabAtIndex: index, collectionView: collectionView, isSelected: isSelected)
    }
    
    func getDynamicCellSize(_ view: UXPagerView, sizeForTabAtIndex index: IndexPath, collectionView: UICollectionView, isSelected: Bool) -> CGSize?{
        let inset = pagerView(view, tabBadgeAtIndex: index.row) == 0 ? UXPageTabCollectionViewCell.widthInsetExcludingTitleAndBadge : UXPageTabCollectionViewCell.widthInsetExcludingTitle
        let font: UIFont? = isSelected ? .systemFont(ofSize: 14, weight: .semibold) : .systemFont(ofSize: 14)
        let titleWidth = pagerView(view, tabTitleAtIndex: index.row).width(for: font) + inset
        return CGSize(width: titleWidth, height: UXPageTabCollectionViewCell.cellHeight)
    }
    
    func pagerView(_ view: UXPagerView, tabBadgeAtIndex index: Int) -> Int{
        return 0
    }
    
    func pagerView(_ view: UXPagerView, didSelectTabAt index: Int) {
        
    }

    func pagerView(_ view: UXPagerView, didSwipeTabTo index: Int) {
        
    }
}
