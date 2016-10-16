//
//  Main1ViewController.swift
//  Example
//
//  Created by ParkKisuk on 2016. 10. 16..
//  Copyright © 2016년 kisukpark. All rights reserved.
//

import UIKit

class Main1ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func openMenu(_ sender: AnyObject) {
    (self.parent as! KSimpleSideMenu).openMenu(completed: nil)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
