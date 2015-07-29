//
//  SettingsViewController.swift
//  SoundCloud Pro
//
//  Created by Austin Feight on 7/28/15.
//  Copyright © 2015 Lost in Flight. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
}

// MARK: - Table View Delegate
extension SettingsViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    if indexPath.section == 0 {
      let votesTableViewController = storyboard?.instantiateViewControllerWithIdentifier(kVotesStoryboardId) as! VotesTableViewController
      votesTableViewController.voteType = (indexPath.row == 0 ? .Up : .Down)
      navigationController!.pushViewController(votesTableViewController, animated: true)
    } else {
      
    }
  }
}