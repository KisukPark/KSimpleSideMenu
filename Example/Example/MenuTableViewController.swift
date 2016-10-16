//
//  MenuTableViewController.swift
//  Example
//
//  Created by ParkKisuk on 2016. 10. 16..
//  Copyright © 2016년 kisukpark. All rights reserved.
//

import UIKit

let menuList = ["To Main1", "To Main2"]

class MenuTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension MenuTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = menuList[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      let main1 = storyboard?.instantiateViewController(withIdentifier: "Main1ViewController") as! Main1ViewController
      self.changeMainViewController(main1)
    } else if indexPath.row == 1 {
      let main2 = storyboard?.instantiateViewController(withIdentifier: "Main2ViewController") as! Main2ViewController
      self.changeMainViewController(main2)
    }
  }
  
  /*
   Main and menu controllers are added as child view controllers to ContainerViewController,
   so that you can access ContainerViewController by self.parent.

   And then, just call its parent's
   
      changeMainViewContrller(_ v: UIViewController,
                              closeMenu: Bool, 
                              completed: (() -> Void)?)
   
   to change main view controller
   */
  private func changeMainViewController(_ viewController: UIViewController) {
    (self.parent as! KSimpleSideMenu).changeMainViewController(viewController,
                                                               closeMenu: true,
                                                               completed: nil)
  }
}
