//
//  DateExtension.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/6/17.
//

import Foundation
import SwiftDate

extension Date {
    func isSameMonth(_ date: Date) -> Bool {
        return date.year == self.year && date.month == self.month
    }
}
