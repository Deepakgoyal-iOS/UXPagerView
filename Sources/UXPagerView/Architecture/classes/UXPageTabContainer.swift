//
//  UXPagerTabContainer.swift
//  Powerplay
//
//  Created by Deepak Goyal on 02/04/23.
//

import UIKit

@MainActor
protocol UXPagerTabContainerDelegate: AnyObject{
    func numberOfTabs() -> Int
    func cellForTabRow(_ collectionView: UICollectionView, atIndex index: IndexPath, isSelected: Bool) -> UICollectionViewCell?
    func didSelectTab(atIndex index: Int)
    func sizeForTab(_ collectionView: UICollectionView, atIndex index: IndexPath, isSelected: Bool) -> CGSize?
}

class UXPageTabContainer: UIView{
    
    @IBOutlet weak var cvTabs: UICollectionView!
    weak var delegate: UXPagerTabContainerDelegate?
    @IBOutlet weak var cvFlowLayout: UICollectionViewFlowLayout!
    private var selectedIndex = 0
    
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
        cvTabs.dataSource = self
        cvTabs.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadTabs(withSelectedIndex: selectedIndex)
    }
    
    func registerCells(cellIds: [String]){
        
        cellIds.unique().forEach({ id in
            
            let nib = UINib(nibName: id, bundle: Bundle.module) ?? UINib(nibName: id, bundle: nil)
            cvTabs.register(nib, forCellWithReuseIdentifier: id)
        })
    }
    
    func reloadTabs(withSelectedIndex index: Int){
        
        if index < cvTabs.numberOfItems(inSection: 0), index >= 0{

            self.cvTabs.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }

        selectedIndex = index
        self.cvTabs.reloadData()
    }
    
    func set(isBounceOnScroll: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.cvTabs.bounces = isBounceOnScroll
        }
    }
    
    func set(backgroundColor: UIColor) {
        DispatchQueue.main.async { [weak self] in
            self?.cvTabs.backgroundColor = backgroundColor
        }
    }

}
extension UXPageTabContainer: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfTabs() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return delegate?.cellForTabRow(collectionView, atIndex: indexPath, isSelected: selectedIndex == indexPath.row) ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        delegate?.didSelectTab(atIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return delegate?.sizeForTab(collectionView, atIndex: indexPath, isSelected: selectedIndex == indexPath.row) ?? CGSize(width: cvTabs.bounds.width/3, height: cvTabs.bounds.height)
    }
}

