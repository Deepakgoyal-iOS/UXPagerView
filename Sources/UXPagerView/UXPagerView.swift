//
//  UXPagerView.swift
//  Powerplay
//
//  Created by Deepak Goyal on 05/04/23.
//

import UIKit

public class UXPagerView: UIView{
    
    // MARK: Use this page view as your subview
    
    @IBOutlet weak var tabView: UXPageTabContainer!
    @IBOutlet weak var pageView: UXPageContainer!
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!

    // Storing pages for optimisation.
    // Note - Cached Page Limit should be an even integer .
    ///`In case of cachedPageLimit = 2`
    ///`Total Pages cached = 3 (1 Left & 1 Right) & 1 itself
    ///`(If jumped to index)= 4 (1 Left & 1 Right) & 1 itself + lastaccessed
    private var cachedPages = [Int: UIViewController]()
    private var cachedPageLimit = 2
    private var lastAccessedPageIndex = 0
    private var isTabSelectionEnabled: Bool = true
    private var containerBackgroundColor: UIColor = .white
    
    public static let defaultTabHeight = 42.0

    /// `Returns -` all the cached pages
    // Value count is at-most [`cachedPageLimit` + 2]
    public var loadedPages: [UIViewController]{
        return Array(cachedPages.values)
    }
    
    public internal(set) var selectedTabIndex: Int = 0 {
        didSet{
            restorePages(forIndex: selectedTabIndex)
            reloadData()
        }
    }

    /// `Default tab to show selected.
    public var defaultSelectedTab = 0
    
    /// `Delegate to render data
    public weak var delegate: UXPagerViewDelegate?{
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
    
    public override func layoutSubviews() {
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
    
    /// Call to refresh tab & page view
    public func reloadData(){
        tabView.reloadTabs(withSelectedIndex: selectedTabIndex)
        pageView.reloadPage(withSelectedIndex: selectedTabIndex)
    }
    
    /// Call to clear the cached page at particular index if exists.
    /// - Parameter index: Cached page index to be cleared,
    ///                    If index is not passed all pages gets cleared.
    public func clearCachedPage(atIndex index: Int? = nil){
        if let index{
            cachedPages[index] = nil
            return
        }
        cachedPages.removeAll()
    }
    
    /// Call to clear the cached page at particular index if exists.
    /// - Parameter index: Cached page index to be cleared,
    ///                    If index is not passed all pages gets cleared.
    public func set(cachedPageLimit: Int){
        self.cachedPageLimit = cachedPageLimit
    }
    
    /// Call to select particular index in pager view
    /// - Parameter index: If index is less than 0 and if index is greater than number of pages then it                                            returns without selecting page index.
    public func set(selectedTabIndex: Int) {
        
        guard let numberOfPages = delegate?.numberOfPages(self), selectedTabIndex < numberOfPages, selectedTabIndex >= 0 else { return }
        
        self.selectedTabIndex = selectedTabIndex
    }
    
    
    /// Call this method for getting page at tab index
    /// - Parameters:
    ///   - index: Tab Index
    ///   - returns: Page / UIViewController at index if present else returns `nil`
    public func pageForTab(atIndex index: Int) -> UIViewController?{
        return cachedPages[index]
    }
    
    public func set(isBounceOnScroll: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.tabView.set(isBounceOnScroll: isBounceOnScroll)
        }
    }
    
    public func set(tabBackgroundColor: UIColor) {
        DispatchQueue.main.async { [weak self] in
            self?.tabView.set(backgroundColor: tabBackgroundColor)
        }
    }
    
    public func set(containerBackgroundColor: UIColor) {
        DispatchQueue.main.async { [weak self] in
            self?.containerBackgroundColor = containerBackgroundColor
        }
    }

    public func set(isTabViewHidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.tabView.isHidden = isTabViewHidden
        }
    }
    
    public func set(isSwipeEnabled: Bool) {
        pageView.set(isSwipeEnabled: isSwipeEnabled)
    }
    
    public func set(tabBarHeight: CGFloat) {
        self.tabBarHeightConstraint.constant = tabBarHeight
    }
    
    public func set(isTabSelectionEnabled: Bool) {
        self.isTabSelectionEnabled = isTabSelectionEnabled
    }
    
    public func layoutPageSubViews() {
        self.pageView.layoutSubviews()
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

                
        cell.vcContainer.backgroundColor = containerBackgroundColor
        
        if index.row == selectedTabIndex {
            cell.setViewController(self.getPage(atIndex: index.row), cachedControllers: cachedPages)
        } else {
            cell.setViewController(nil, cachedControllers: cachedPages)
        }
        
        return cell
    }
    
     func didSelectPage(atIndex index: Int) {
        selectedTabIndex = index
        delegate?.pagerView(self, didSelectTabAt: index)
    }
    
    func didSwipeContainer(atIndex index: Int) {
        delegate?.pagerView(self, didSwipeTabTo: index)
    }
    
}
// Optimisation Logic
extension UXPagerView {
    
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
extension UXPagerView {
    
    
    /// Call to rebuild page at particular index
    /// - Parameter index: Index to be rebuilt, clears selected page from cache if exists and creates                                           new page.
    public func reloadView(withSelectedIndex index: Int) {
        cachedPages[index] = nil
        selectedTabIndex = index
    }
    
    /// Call to clear particular index and reload page view
    /// - Parameter index: Index you need to clear and reload page
    public func reloadView(atIndex index: Int){
        cachedPages[index] = nil
        let selectedTab = self.selectedTabIndex
        selectedTabIndex = selectedTab
    }
    
    /// Call to clear all cached pages and re build new pages with selected Index
    /// - Parameter index: the index need to be kept selected.
    public func reset(withSelectingIndex index: Int) {
        cachedPages.removeAll()
        selectedTabIndex = index
    }
    
    public func reloadTabView(withSelectedIndex selectedTabIndex: Int) {
        tabView.reloadTabs(withSelectedIndex: selectedTabIndex)
    }
}
