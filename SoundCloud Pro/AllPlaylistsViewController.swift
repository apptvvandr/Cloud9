//
//  AllPlaylistsViewController.swift
//  SoundCloud Pro
//
//  Created by Austin Feight on 7/29/15.
//  Copyright © 2015 Lost in Flight. All rights reserved.
//

import UIKit

let kLoadingCellIdentifier = "loadingCell"
let kNoPlaylistsCellIdentifier = "noPlaylists"

let kOnTheGoPlaylistSection = 0
let kSharedPlaylistSection = 1
let kMyPlaylistSection = 2

class AllPlaylistsViewController: UIViewController {
  var sharedPlaylists: [Playlist]! {
    didSet { tableView.reloadData() }
  }
  
  var myPlaylists: [Playlist]! {
    didSet { tableView.reloadData() }
  }

  @IBOutlet private weak var tableView: UITableView!
  private var pullToRefresh: BOZPongRefreshControl!
}


// MARK: - View Life Cycle
extension AllPlaylistsViewController {
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    loadPlaylists()
  }
  
  override func viewDidAppear(animated: Bool)
  {
    super.viewDidAppear(animated)
    setupTableIfNecessary()
  }
  
  func loadPlaylists()
  {
    pullToRefresh?.finishedLoading()
    myPlaylists = nil
    sharedPlaylists = nil
    
    
    loadSharedPlaylists()
    loadMyPlaylists()
  }

  private func setupTableIfNecessary()
  {
    if pullToRefresh != nil { return }
    
    tableView.dataSource = self
    tableView.delegate = self
    pullToRefresh = BOZPongRefreshControl.attachToTableView(tableView, withRefreshTarget: self, andRefreshAction: "loadPlaylists")
  }
  
  private func loadMyPlaylists()
  {
    SoundCloud.getMyPlaylists { (playlists, error) -> Void in
      if error == nil {
        self.myPlaylists = playlists
      }
      else {
        ErrorHandler.handleNetworkingError("my playlists", error: error)
      }
    }
  }
  
  private func loadSharedPlaylists()
  {
    SoundCloud.getSharedPlaylists { (playlists, error) -> Void in
      if error == nil {
        self.sharedPlaylists = playlists
      }
      else {
        ErrorHandler.handleNetworkingError("shared playlists", error: error)
      }
    }
  }
}

// MARK: - Table View Data Source
extension AllPlaylistsViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 3
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
  {
    switch section {
      case kSharedPlaylistSection: return "Shared Playlists"
      case kMyPlaylistSection: return "My Playlists"
      default: return nil
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    if !rowsLoadedForSection(section) || playlistForSectionIsEmpty(section) { return 1 }
    
    return playlistsForSection(section).count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    if !rowsLoadedForSection(indexPath.section) {
      let loadingCell = tableView.dequeueReusableCellWithIdentifier(kLoadingCellIdentifier, forIndexPath: indexPath) as! LoadingCell
      loadingCell.animate()
      return loadingCell
    }
    else if playlistForSectionIsEmpty(indexPath.section) {
      let cell = tableView.dequeueReusableCellWithIdentifier(kNoPlaylistsCellIdentifier, forIndexPath: indexPath)
      cell.textLabel?.text = "No playlists!"
      return cell
    }
    else {
      let playlistCell = tableView.dequeueReusableCellWithIdentifier(kPlaylistCellIdentifier, forIndexPath: indexPath) as! PlaylistCell
      playlistCell.playlist = playlistForIndexPath(indexPath)
      return playlistCell
    }
  }
  
  private func rowsLoadedForSection(section: Int) -> Bool
  {
    return playlistsForSection(section) != nil
  }
}

// MARK: - UI Actions
extension AllPlaylistsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if let playlist = playlistForIndexPath(indexPath) {
      presentPlaylist(playlist)
    }
  }
  
  @IBAction func addPlaylistTapped(sender: AnyObject)
  {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "New Shared Playlist", style: .Default, handler: { (action) -> Void in
      self.showAddPlaylistAlert(.Shared)
    }))
//    alert.addAction(UIAlertAction(title: "New Playlist", style: .Default, handler: { (action) -> Void in
//      self.showAddPlaylistAlert(.Normal)
//    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
    presentViewController(alert, animated: true, completion: nil)
  }
  
  private func presentPlaylist(playlist: Playlist)
  {
    let playlistVC = PlaylistViewController(playlist: playlist)
    navigationController?.pushViewController(playlistVC, animated: true)
  }
}

// MARK: - Helpers
extension AllPlaylistsViewController {
  private func playlistsForSection(section: Int) -> [Playlist]!
  {
    switch section {
      case kOnTheGoPlaylistSection: return [UserPreferences.onTheGoPlaylist]
      case kSharedPlaylistSection: return sharedPlaylists
      case kMyPlaylistSection: return myPlaylists
      default: fatalError()
    }
  }
  
  private func playlistForIndexPath(indexPath: NSIndexPath) -> Playlist!
  {
    let playlist = playlistsForSection(indexPath.section)
    return playlist.count > 0 ? playlist[indexPath.row] : nil
  }
  
  private func playlistForSectionIsEmpty(section: Int) -> Bool
  {
    return playlistsForSection(section).count == 0
  }

  private func showAddPlaylistAlert(playlistType: PlaylistType)
  {
    let alert = UIAlertController(title: "New \(playlistType.rawValue) Playlist", message: nil, preferredStyle: .Alert)
    alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "name"
    }
    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { [unowned alert] (action) -> Void in
      let name = alert.textFields!.first!.text!
      SoundCloud.createPlaylistWithName(name, type: playlistType, callback: self.createPlaylistHandler)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
    presentViewController(alert, animated: true, completion: nil)
  }
  
  func createPlaylistHandler(success: Bool, error: NSError?)
  {
    if error == nil {
      loadPlaylists()
    }
    else {
      ErrorHandler.handleNetworkingError("creating playlists", error: error!)
    }
  }
}

// MARK: - Pull To Refresh
extension AllPlaylistsViewController {
  func scrollViewDidScroll(scrollView: UIScrollView)
  {
    pullToRefresh.scrollViewDidScroll()
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
  {
    pullToRefresh.scrollViewDidEndDragging()
  }
}