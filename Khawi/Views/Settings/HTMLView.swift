//
//  HTMLView.swift
//  Khawi
//
//  Created by Karim Amsha on 8.11.2023.
//

import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {
    let html: String
    @Binding var contentHeight: CGFloat

    init(html: String, contentHeight: Binding<CGFloat>) {
        self.html = html
        self._contentHeight = contentHeight
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = context.coordinator

        webView.loadHTMLString(html, baseURL: nil)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HTMLView

        init(_ parent: HTMLView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.scrollHeight") { result, error in
                if let height = result as? CGFloat {
                    self.parent.contentHeight = height
                }
            }
        }
    }
}
