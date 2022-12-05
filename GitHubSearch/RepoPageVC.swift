//
//  RepoPageVC.swift
//  GitHubSearch
//
//  Created by Wilson Garcia on 12/2/22.
//

import UIKit
import WebKit

class RepoPageVC: UIViewController {
    var url: URL?
    @IBOutlet private weak var repoPageWebView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = true
        guard let url = url else { return }
        self.repoPageWebView.load(URLRequest(url: url))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.openInSafari))
    }
    
    @objc func openInSafari() {
        guard let url = url else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

extension RepoPageVC: UIWebViewDelegate {
    private func webViewDidStartLoad(_ webView: WKWebView) {
        activityIndicator.startAnimating()
    }

    private func webViewDidFinishLoad(_ webView: WKWebView) {
        activityIndicator.stopAnimating()
    }
}
