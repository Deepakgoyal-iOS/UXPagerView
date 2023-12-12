//
//  UXPagerView.swift
//  Powerplay
//
//  Created by Deepak Goyal on 05/04/23.
//

import UIKit

class UXPagerView: UIView{
    
    // MARK: Use this page view as your subview 
    
    @IBOutlet weak var tabView: UXPageTabContainer!
    @IBOutlet weak var pageView: UXPageContainer!

    // Storing pages for optimisation.
    // Note - Cached Page Limit should be an even integer .
    ///`In case of cachedPageLimit = 2`
    ///`Total Pages cached = 3 (1 Left & 1 Right) & 1 itself
    ///`(If jumped to index)= 4 (1 Left & 1 Right) & 1 itself + lastaccessed
    private var cachedPages = [Int: UIViewController]()
    private let cachedPageLimit = 2
    private var lastAccessedPageIndex = 0
    
    private(set) var selectedTabIndex: Int = 0 {
        didSet{
            restorePages(forIndex: selectedTabIndex)
            reloadView()
        }
    }

    /// `Default tab to show selected.
    var defaultSelectedTab = 0
    
    /// `Delegate to render data
    weak var delegate: UXPagerViewDelegate?{
        didSet{
            registerCells()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initializeUI()
    }
    
    private func registerCells(){
        tabView.registerCells(cellIds: delegate?.getTabCellIdentifiers() ?? [])
        pageView.registerCells(cellIds: [UXPageCollectionViewCell.id])
    }
    
    private func initializeUI(){
        tabView.delegate = self
        pageView.delegate = self
        selectedTabIndex = defaultSelectedTab
    }
    
    private func reloadView(){
        tabView.reloadTabs(withSelectedIndex: selectedTabIndex)
        pageView.reloadPage(withSelectedIndex: selectedTabIndex)
    }
    
    func reset(withSelectingIndex index: Int) {
        cachedPages.removeAll()
        selectedTabIndex = index
    }
    
    func reloadView(withSelectedIndex index: Int) {
        cachedPages[index] = nil
        selectedTabIndex = index
    }
    
    
    func set(isBounceOnScroll: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.tabView.set(isBounceOnScroll: isBounceOnScroll)
        }
    }
    
    func set(backgroundColor: UIColor) {
        DispatchQueue.main.async { [weak self] in
            self?.tabView.set(backgroundColor: backgroundColor)
        }
    }
    
    func set(selectedTabIndex: Int) {
        self.selectedTabIndex = selectedTabIndex
    }
    
    func set(isTabViewHidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.tabView.isHidden = isTabViewHidden
        }
    }
    
    func reloadView(atIndex index: Int){
        cachedPages[index] = nil
        let selectedTab = self.selectedTabIndex
        selectedTabIndex = selectedTab
    }
    
    private func restorePages(forIndex accessedIndex: Int){
        
        var storedPages = [Int: UIViewController]()
        for index in 1...Int(cachedPageLimit/2){
            let prevPageIndex = accessedIndex - index
            let nextPageIndex = accessedIndex + index
            storedPages[prevPageIndex] = getPage(atIndex: prevPageIndex) //Right Page
            storedPages[nextPageIndex] = getPage(atIndex: nextPageIndex) //Left Page
        }
        storedPages[accessedIndex] = getPage(atIndex: accessedIndex)
        
        // chaining used here because there exists a case, where lastAccessedPageIndex == accessedIndex and `pageAtIndex` delegate method is called twice.
        storedPages[lastAccessedPageIndex] = storedPages[lastAccessedPageIndex] ?? getPage(atIndex: lastAccessedPageIndex)
        lastAccessedPageIndex = accessedIndex
        self.cachedPages = storedPages
    }
    
    private func getPage(atIndex index: Int) -> UIViewController? {
        
        guard index >= 0, index < numberOfPageItems() else { return nil }
        return cachedPages[index] ?? delegate?.pagerView(self, pageAtIndex: index)
    }
}
extension UXPagerView: UXPagerTabContainerDelegate{
    
    func numberOfTabs() -> Int {
        return delegate?.numberOfPages(self) ?? 0
    }
    
    func cellForTabRow(_ collectionView: UICollectionView, atIndex index: IndexPath, isSelected: Bool) -> UICollectionViewCell? {
        delegate?.pagerView(self, cellForTabAtIndex: index, collectionView: collectionView, isSelected: isSelected)
    }
    
    func didSelectTab(atIndex index: Int) {
        selectedTabIndex = index
        delegate?.pagerView(self, didSelectTabAt: index)
    }
    
    func sizeForTab(_ collectionView: UICollectionView, atIndex index: IndexPath, isSelected: Bool) -> CGSize? {
        delegate?.pagerView(self, sizeForTabAtIndex: index, collectionView: collectionView, isSelected: isSelected)
    }
}
extension UXPagerView: UXPageContainerDelegate{
    
    func numberOfPageItems() -> Int {
       return delegate?.numberOfPages(self) ?? 0
    }
    
    func cellForPageRow(_ collectionView: UICollectionView, atIndex index: IndexPath) -> UICollectionViewCell? {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UXPageCollectionViewCell.id, for: index) as? UXPageCollectionViewCell else {
           return UICollectionViewCell()
        }
        cell.setViewController(self.getPage(atIndex: index.row), cachedControllers: cachedPages)
        return cell
    }
    
    func didSelectPage(atIndex index: Int) {
        selectedTabIndex = index
        delegate?.pagerView(self, didSelectTabAt: index)
    }
    
}
