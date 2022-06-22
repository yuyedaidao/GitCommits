//
//  Appdelegate.swift
//  GitCommits (macOS)
//
//  Created by 王叶庆 on 2022/5/19.
//

import Foundation
import AppKit
import GRDB
import SwiftDate

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
        SwiftDate.defaultRegion = Region.current
    }
}
