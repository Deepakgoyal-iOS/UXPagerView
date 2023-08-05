//
//  ViewController.swift
//  UXPagerView
//
//  Created by Deepak Goyal on 05/08/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showPageButtonAction(_ sender: Any) {
        pushPagerController()
    }
    
    private func pushPagerController(){
        
        var pageViewControllers = [UXPageBaseViewControllerProtocol]()
        
        if let firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OneViewController") as? OneViewController{
            pageViewControllers.append(firstViewController)
        }
        
        if let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwoViewController") as? TwoViewController{
            pageViewControllers.append(secondViewController)
        }
        
        if let thirdViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThreeViewController") as? ThreeViewController{
            pageViewControllers.append(thirdViewController)
        }
        
        if let pagerController = UIStoryboard(name: "Pager", bundle: nil).instantiateViewController(withIdentifier: "UXPagerViewController") as? UXPagerViewController{
            pagerController.setViewControllers(pageViewControllers)
            pagerController.setFixedVisibleTabs(3)
            self.navigationController?.pushViewController(pagerController, animated: true)
        }
        
      
    }

}

