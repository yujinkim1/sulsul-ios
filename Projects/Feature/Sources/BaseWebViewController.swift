//
//  BaseWebViewController.swift
//  Feature
//
//  Created by 이범준 on 4/18/24.
//

import UIKit
import Combine
import WebKit
import SnapKit
import Then

protocol BaseWebViewControllerDelegate: AnyObject {
    func webVCDidDisappear()
}

public class BaseWebViewController: UIViewController {
    weak var delegate: BaseWebViewControllerDelegate?
    var coordinator: CommonBaseCoordinator?
    
    private lazy var webView = WKWebView().then {
        $0.allowsBackForwardNavigationGestures = true
        $0.navigationDelegate = self
        $0.scrollView.showsVerticalScrollIndicator = false
    }
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        openWebView()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        delegate?.webVCDidDisappear()
    }
    
    private func addViews() {
        view.addSubview(webView)
    }
    
    private func makeConstraints() {
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func openWebView() {
        let urlRequest = URLRequest(url: url)
        
//        DispatchMain.async { [weak self] in
//            self?.webView.load(urlRequest)
//        }
        
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(urlRequest)
        }
    }
}

// MARK: - WKNavigationDelegate
extension BaseWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
