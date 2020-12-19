//
//  ViewController.swift
//  WebViewWithPreLoaderApp
//
//  Created by Денис on 19.12.2020.
//

import UIKit
import WebKit

final class ViewController: UIViewController {
    
    // MARK: - Properties
    private var webView: WKWebView!
    private let preLoaderView = PreLoaderView()
    
    // MARK: - Overrided methods
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.frame)
        webView.navigationDelegate = self
        view.addSubview(webView)
        loadWeb()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if webView.isLoading {
            showPreLoader()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                guard let self = self else { return }
                self.hidePreLoader(loader: self.preLoaderView)
            }
        }
    }
}

// MARK: - Navigation delegate
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hidePreLoader(loader: preLoaderView)
    }
}

// MARK: - Private methods
extension ViewController {
    private func showPreLoader() {
        preLoaderView.modalPresentationStyle = .fullScreen
        present(preLoaderView, animated: true, completion: nil)
    }
    
    private func hidePreLoader(loader: PreLoaderView) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
    
    private func loadWeb() {
        guard let myUrl = URL(string: "https://www.salesforce.com/products/platform/overview/") else { return }
        let myRequest = URLRequest(url: myUrl)
        webView.load(myRequest)
    }
}

