//
//  MenuViewController.swift
//  Twitter
//
//  Created by ruthie_berman on 10/6/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!

  var check = false

  var navigationViewController: UIViewController! {
    didSet {
      view.layoutIfNeeded()
      menuView.addSubview(navigationViewController.view)
    }
  }

  var contentViewController: UIViewController! {
    didSet(oldContentViewController) {
      view.layoutIfNeeded()

      if oldContentViewController != nil {
        oldContentViewController.willMove(toParentViewController: nil)
        oldContentViewController.view.removeFromSuperview()
        oldContentViewController.didMove(toParentViewController: nil)
      }

      contentViewController.willMove(toParentViewController: self)
      contentView.addSubview(contentViewController.view)
      contentViewController.didMove(toParentViewController: self)
      UIView.animate(withDuration: 0.3) { 
        self.leftMarginConstraint.constant = 0
        self.view.layoutIfNeeded()
      }
    }
  }
  private var originalLeftMargin: CGFloat!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: view)
    let velocity = sender.velocity(in: view)
    if sender.state == UIGestureRecognizerState.began {
      originalLeftMargin = leftMarginConstraint.constant
    } else if sender.state == UIGestureRecognizerState.changed {
      leftMarginConstraint.constant = originalLeftMargin + translation.x
    } else if sender.state == UIGestureRecognizerState.ended {
      UIView.animate(withDuration: 0.3, animations: {
        if velocity.x > 0 {
          self.leftMarginConstraint.constant = self.view.frame.size.width - 200
        } else {
          self.leftMarginConstraint.constant = 0
        }
        self.view.layoutIfNeeded()
      })
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
