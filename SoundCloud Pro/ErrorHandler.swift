//
//  ErrorHandler.swift
//  SoundCloud Pro
//
//  Created by Austin Feight on 7/28/15.
//  Copyright © 2015 Lost in Flight. All rights reserved.
//

import UIKit

class ErrorHandler {
  class func handleNetworkingError(requestDescription: String, error: NSError)
  {
    let alert = SCLAlertView()
    alert.showError("There was a problem fetching \(requestDescription), please check your internet connection and try again.", subTitle: nil, closeButtonTitle: "Ok", duration: 2)
    NSLog("Error fetching \(requestDescription), details: \(error)")
  }
}
