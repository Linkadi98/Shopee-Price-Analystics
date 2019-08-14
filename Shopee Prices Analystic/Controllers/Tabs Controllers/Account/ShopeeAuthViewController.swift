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
    var result: String?
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        let url = URL(string: "https://partner.shopeemobile.com/api/v1/shop/auth_partner?id=842940&token=90c79428d43afab7847ecdf30f2486bc4e5499b490f4244eec0acfab51736225&redirect=https%3A%2F%2Fwww.google.com")!
        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let prefix = "https://www.google.com/?shop_id="
        if webView.url!.absoluteString.hasPrefix(prefix) {
            shopId = String(webView.url!.absoluteString.dropFirst(prefix.count))

            UIApplication.shared.beginIgnoringInteractionEvents()

            let activityIndicator = initActivityIndicator()
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()

            self.addShop(shopId: shopId!, shopName: "Shop xyz") { result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    self.result = result
                    activityIndicator.stopAnimating()
                    if activityIndicator.isAnimating == false {
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            }
            performSegue(withIdentifier: "ShopeeAuthVCUnwindToListShopsTVC", sender: nil)
        }
    }
}
