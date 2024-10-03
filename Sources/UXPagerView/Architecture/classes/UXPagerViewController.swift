//
//  UXPagerViewController.swift
//  Powerplay
//
//  Created by Deepak Goyal on 31/03/23.
//

import UIKit

class UXPagerViewController: UIViewController{
    
    @IBOutlet weak var pageView: UXPagerView!
    
    private(set) var viewControllers: [UXPageBaseViewControllerProtocol] = []
    private(set) var noOfVisibleTabs = 0
    private(set) var defaultSelectedTab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.pageView.defaultSelectedTab = defaultSelectedTab
        pageView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true

    }

    func setViewControllers(_ viewControllers: [UXPageBaseViewControllerProtocol]){
        self.viewControllers = viewControllers
    }
    
    func setFixedVisibleTabs(_ noOfTabs: Int){
        self.noOfVisibleTabs = noOfTabs
    }
    
    func setDefaultSelected(tabIndex: Int){
        self.defaultSelectedTab = tabIndex
    }
}
extension UXPagerViewController: UXPagerViewDelegate{
    
    func pagerView(_ view: UXPagerView, tabBadgeAtIndex index: Int) -> Int {
        viewControllers[safeIndex: index]?.getTabBadgeCount() ?? 0
    }
    
    func pagerView(_ view: UXPagerView, tabTitleAtIndex index: Int) -> String {
        viewControllers[safeIndex: index]?.getTabTitle() ?? ""
    }
    
    func pagerView(_ view: UXPagerView, pageAtIndex index: Int) -> UIViewController? {
        viewControllers[safeIndex: index] as? UIViewController
    }
    
    func numberOfPages(_ view: UXPagerView) -> Int {
        viewControllers.count
    }
    
    func pagerView(_ view: UXPagerView, cellForTabAtIndex index: IndexPath, collectionView: UICollectionView, isSelected: Bool) -> UICollectionViewCell? {
        return viewControllers[safeIndex: index.row]?.getTab(collectionView, indexPath: index, isSelected: isSelected)
    }
    
    func getTabCellIdentifiers() -> [String] {
        viewControllers.map({ $0.getTabCellIdentifier() }).unique()
    }
    
    func pagerView(_ view: UXPagerView, sizeForTabAtIndex index: IndexPath, collectionView: UICollectionView, isSelected: Bool) -> CGSize? {
        if noOfVisibleTabs > 0{
            return CGSize(width: collectionView.bounds.width/CGFloat(noOfVisibleTabs), height: collectionView.bounds.height)
        }
        return getDynamicCellSize(view, sizeForTabAtIndex: index, collectionView: collectionView, isSelected: isSelected)
    }
}
