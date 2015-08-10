//
//  PlaylistPickerViewController.swift
//  SoundCloud Pro
//
//  Created by Austin Feight on 8/4/15.
//  Copyright © 2015 Lost in Flight. All rights reserved.
//

import UIKit

protocol PlaylistPickerDelegate: NSObjectProtocol {
  func playlistPicker(playlistPicker: PlaylistPickerViewController, didSelectPlaylist playlist: Playlist)
  func playlistPickerDidTapCancel(playlistPicker: PlaylistPickerViewController)
}

class PlaylistPickerViewController: UITableViewController {
  var playlists: [Playlist] = [] {
    didSet { tableView.reloadData() }
  }
  
  weak var delegate: PlaylistPickerDelegate?
}

// MARK: - View Life Cycle
extension PlaylistPickerViewController {
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
    tableView.registerNib(PlaylistCell.nib, forCellReuseIdentifier: kPlaylistCellIdentifier)
    loadPlaylists()
  }
  
  private func loadPlaylists()
  {
    let alert = Utilities.showLoadingAlert("Loading playlists", onViewController: self)
    
    SoundCloud.getSharedPlaylists({ (sharedPlaylists, error) -> Void in
      alert.hideView()
      
      if error == nil {
        self.playlists = sharedPlaylists
      } else {
        ErrorHandler.handleNetworkingError("fetching playlists", error: error)
      }
    })
  }
  
  func cancel()
  {
    delegate?.playlistPickerDidTapCancel(self)
  }
}

// MARK: - Table view data source + Delegate
extension PlaylistPickerViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return playlists.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(kPlaylistCellIdentifier, forIndexPath: indexPath) as! PlaylistCell
    cell.playlist = playlists[indexPath.row]
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    delegate?.playlistPicker(self, didSelectPlaylist: playlists[indexPath.row])
  }
}
