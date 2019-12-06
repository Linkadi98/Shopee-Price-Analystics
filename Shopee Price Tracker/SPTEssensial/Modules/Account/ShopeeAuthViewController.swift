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
        let url = URL(string: "https://partner.shopeemobile.com/api/v1/shop/auth_partner?id=842939&token=f9254ee3be45fc426114b133a03ea24ded14b8a123529e5026c9c54064922217&redirect=http://192.168.1.8:8081")!
        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let prefix = "http://192.168.1.8:8081" + "/?shop_id="
        if webView.url!.absoluteString.hasPrefix(prefix) {
            shopId = String(webView.url!.absoluteString.dropFirst(prefix.count))

            self.performSegue(withIdentifier: "ShopeeAuthVCUnwindToListShopsTVC", sender: nil)
        }
    }
}
