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

        let url = URL(string: "https://partner.uat.shopeemobile.com/api/v1/shop/auth_partner?id=840386&token=10c252cfeb43ef9935ef0af2da709c91b040c63f2811242387721b455f802880&redirect=https%3A%2F%2Fwww.google.com")!
        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let prefix = "https://www.google.com/?shop_id="
        if webView.url!.absoluteString.hasPrefix(prefix) {

            shopId = String(webView.url!.absoluteString.dropFirst(prefix.count))
            self.performSegue(withIdentifier: "ShopeeAuthVCUnwindToListShopsTVC", sender: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
