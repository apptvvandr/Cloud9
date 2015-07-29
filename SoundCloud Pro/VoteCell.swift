//
//  VoteCellTableViewCell.swift
//  SoundCloud Pro
//
//  Created by Austin Feight on 7/28/15.
//  Copyright © 2015 Lost in Flight. All rights reserved.
//

import UIKit

class VoteCell: UITableViewCell {
  var track: Track! {
    didSet {
      textLabel?.text = track.title
      detailTextLabel?.text = track.artist
    }
  }
}

// MARK: - Life Cycle
extension VoteCell {
}
