//
//  ThreeViewController.swift
//  UXPagerView
//
//  Created by Deepak Goyal on 05/08/23.
//

import UIKit

class ThreeViewController: UIViewController, UXPageBaseViewControllerProtocol {
    
    func getTabTitle() -> String {
        "Three"
    }
    
    func getTabBadgeCount() -> Int {
        1
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
