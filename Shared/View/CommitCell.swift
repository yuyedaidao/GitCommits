//
//  CommitCell.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/6/17.
//

import SwiftUI
import SwiftDate

struct CommitCell: View {
    let commit: Commit
    let now = Date()
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .bottom, spacing: 4) {
                Text(commit.message.trimmingCharacters(in: .newlines))
                    .lineLimit(nil)
                    .font(.title2)
                Button {
                    guard let url = URL(string: commit.url) else {return}
                    NSWorkspace.shared.open(url)
                } label: {
                    Image(systemName: "chevron.left.forwardslash.chevron.right").resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 10)
                        .foregroundColor(Color.black.opacity(0.3))
                }
            }
            HStack(spacing: 10) {
                Text(commit.repoName)
                Text(commit.author)
                Text(commit.date.isSameMonth(now) ? commit.date.toFormat("MM/dd HH:mm"): commit.date.toFormat("yyyy/MM/dd HH:mm"))
            }
            .font(.footnote)
            .foregroundColor(Color.black.opacity(0.3))
            .padding(.top, 2)
            Divider().padding(.top, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CommitCell_Previews: PreviewProvider {
    static var previews: some View {
        CommitCell(commit: Commit(repoName: "sparrow", repoType: .gitlab, cid: "aaaaa", date: Date(), message: "处理粉丝 动态 问答 直播无法自由显示隐藏的问题 处理粉丝 动态 问答 直播无法自由显示隐藏的问题 处理粉丝 动态 问答 直播无法自由显示隐藏的问题", author: "WYQ", email: "wyqpadding@gmail.com", url: "https://codecenter.iqilu.com:8181/wyq/sparrow/-/commit/6855ded99d6ef5935bc959639718d2113e2f7d6a"))
    }
}
