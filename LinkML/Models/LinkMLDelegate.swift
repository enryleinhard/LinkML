//
//  LinkMLDelegate.swift
//  LinkML
//
//  Created by Enryl Einhard on 8/3/2025.
//

import UIKit

class LinkMLDelegate: NSObject, UIApplicationDelegate {
    var downloadManager: DownloadManager?
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        if let downloadManager = downloadManager, identifier == downloadManager.sessionIdentifier {
            downloadManager.backgroundSessionCompletionHandler = completionHandler
        }
    }
    
}
