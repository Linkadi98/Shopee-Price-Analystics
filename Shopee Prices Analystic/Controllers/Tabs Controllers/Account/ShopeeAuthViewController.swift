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
        let url = URL(string: "https://partner.shopeemobile.com/api/v1/shop/auth_partner?id=842939&token=15b7bde67729a19508afc09d8bdf6b1eb499c8607f53aaf41ebf1f0b5dc55ff8&redirect=http%3A%2F%2F172.104.173.222")!
        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let prefix = "http://172.104.173.222:8081/?shop_id="
        if webView.url!.absoluteString.hasPrefix(prefix) {
            shopId = String(webView.url!.absoluteString.dropFirst(prefix.count))

            self.performSegue(withIdentifier: "ShopeeAuthVCUnwindToListShopsTVC", sender: nil)
        }
    }
}
