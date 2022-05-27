//
//  WebView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/25.
//
//
//  WebView.swift
//  Todos
//
//  Created by Bradley Hilton on 6/5/19.
//  Copyright © 2019 Brad Hilton. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {    
    let request: URLRequest
    
    func makeNSView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateNSView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}

#if DEBUG
struct WebView_Previews : PreviewProvider {
    static var previews: some View {
        WebView(request: URLRequest(url: URL(string: "https://www.apple.com")!))
    }
}
#endif
