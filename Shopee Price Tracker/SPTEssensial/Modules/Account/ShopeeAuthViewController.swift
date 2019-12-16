//
//  ShopeeAuthViewController.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 8/5/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import WebKit

class ShopeeAuthViewController: UIViewController, WKNavigationDelegate {

    var shopId: String?
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        let url = URL(string: "https://open.shopee.com/authorize?random=135df19d78f3a9dd&auth_shop=True&id=842939")!
        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let prefix = "http://202.191.56.159:2501" + "/?shop_id="
        if webView.url!.absoluteString.hasPrefix(prefix) {
            shopId = String(webView.url!.absoluteString.dropFirst(prefix.count))

            self.performSegue(withIdentifier: "ShopeeAuthVCUnwindToListShopsTVC", sender: nil)
        }
    }
}
