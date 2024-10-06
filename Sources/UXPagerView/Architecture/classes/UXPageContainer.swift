//
//  UXPageContainer.swift
//  Powerplay
//
//  Created by Deepak Goyal on 02/04/23.
//

import UIKit

@MainActor
protocol UXPageContainerDelegate: AnyObject{
    func numberOfPageItems() -> Int
    func cellForPageRow(_ collectionView: UICollectionView, atIndex index: IndexPath) -> UICollectionViewCell?
    func didSelectPage(atIndex index: Int)
    func didSwipeContainer(atIndex index: Int)
}

class UXPageContainer: UIView{
    
    @IBOutlet weak var cvPages: UICollectionView!
    weak var delegate: UXPageContainerDelegate?
    private var selectedIndex: Int = 0
    private var isSwipeEnabled: Bool = true
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()
        initializeUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        initializeUI()
    }
    
    private func initializeUI(){
        cvPages.dataSource = self
        cvPages.delegate = self
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        leftSwipe.direction = .left
        cvPages.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight(_:)))
        rightSwipe.direction = .right
        cvPages.addGestureRecognizer(rightSwipe)
        cvPages.isScrollEnabled = false
    }
    
    func registerCells(cellIds: [String]){
        
        cellIds.forEach({ id in
            cvPages.register(UINib(nibName: id, bundle: nil), forCellWithReuseIdentifier: id)
        })
    }
    
    func set(isSwipeEnabled: Bool) {
        self.isSwipeEnabled = isSwipeEnabled
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadPage(withSelectedIndex: selectedIndex)
    }
    
    func reloadPage(withSelectedIndex index: Int){
        
        let shouldAnimate = selectedIndex == index
        selectedIndex = index
        let horizontalContentOffset = cvPages.bounds.width * CGFloat(index)
        cvPages.setContentOffset(CGPoint(x: horizontalContentOffset, y: cvPages.bounds.origin.y), animated: shouldAnimate)
        cvPages.reloadData()
    }

}
extension UXPageContainer: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfPageItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return delegate?.cellForPageRow(collectionView, atIndex: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    @objc func didSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        guard (selectedIndex + 1) < cvPages.numberOfItems(inSection: 0), isSwipeEnabled else { return }
        selectedIndex += 1
        scrollPage(at: selectedIndex)
        self.delegate?.didSelectPage(atIndex: selectedIndex)
        self.delegate?.didSwipeContainer(atIndex: selectedIndex)
    }
    
    @objc func didSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        guard (selectedIndex - 1) >= 0, isSwipeEnabled else { return }
        selectedIndex -= 1
        scrollPage(at: selectedIndex)
        self.delegate?.didSelectPage(atIndex: selectedIndex)
        self.delegate?.didSwipeContainer(atIndex: selectedIndex)
    }
    
    private func scrollPage(at index: Int) {
        guard index < cvPages.numberOfItems(inSection: 0), index >= 0 else { return }
        let pageWidth: CGFloat = cvPages.bounds.width
        let contentOffset = CGPoint(x: CGFloat(index) * pageWidth, y: cvPages.bounds.origin.y)
        cvPages.setContentOffset(contentOffset, animated: true)
    }
}
