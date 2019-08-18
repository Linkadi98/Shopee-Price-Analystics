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
        let url = URL(string: "https://partner.uat.shopeemobile.com/api/v1/shop/auth_partner?id=840386&token=10c252cfeb43ef9935ef0af2da709c91b040c63f2811242387721b455f802880&redirect=https%3A%2F%2Fwww.google.com")!
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

            self.addShop(shopId: shopId!) { result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    self.result = result
                    activityIndicator.stopAnimating()
                    if activityIndicator.isAnimating == false {
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    self.performSegue(withIdentifier: "ShopeeAuthVCUnwindToListShopsTVC", sender: nil)
                }
            }
        }
    }
}
