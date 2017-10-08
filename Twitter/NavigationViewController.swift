//
//  NavigationViewController.swift
//  Twitter
//
//  Created by ruthie_berman on 10/6/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!

  var menuViewController: MenuViewController?
  private var viewControllers: [UIViewController] = [UIViewController]()
  private var viewControllerNames = ["Profile", "Timeline", "Mentions", "", ""]

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let profile = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
    let timeline = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
    let mentions = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as? UINavigationController
    let mentionsVC = mentions?.topViewController as? TweetsViewController
    mentionsVC?.showMentions = true

    viewControllers = [profile, timeline, mentions!]

    menuViewController?.contentViewController = viewControllers[1]

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NavigationCell", for: indexPath) as! NavigationCell
    cell.label.text = viewControllerNames[indexPath.row]
    if indexPath.row >= viewControllers.count {
      cell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row >= viewControllers.count { return }
    menuViewController?.contentViewController = viewControllers[indexPath.row]
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
