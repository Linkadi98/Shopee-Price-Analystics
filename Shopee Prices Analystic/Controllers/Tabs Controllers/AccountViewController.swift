//
//  AccountViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/16/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class AccountViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(AccessToken.current)
        if let userData = UserDefaults.standard.data(forKey: "currentUser"), let currentUser = try? JSONDecoder().decode(User.self, from: userData) {
            accountName.text = currentUser.name!

            DispatchQueue(label: "loadAvatar").async {
                do {
                    let data = try Data(contentsOf:URL(string: currentUser.image!)!)
                    DispatchQueue.main.async {
                        self.avatar.image = UIImage(data: data)
                    }
                } catch {
                    print("Can't load Avatar!")
                }
            }
        }

        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.backgroundColor = .red
        
        print(GIDSignIn.sharedInstance()?.currentUser)
        print("abc")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logout(_ sender: Any) {
        print("singout")
        // Sign Out
        if AccessToken.current != nil {
            print("fblogout")
            LoginManager().logOut()
        } else {
            print(GIDSignIn.sharedInstance()?.currentUser)
            print("gglogout")
            GIDSignIn.sharedInstance()?.signOut()
        }

        UserDefaults.standard.removeObject(forKey: "currentUser")
        // Back to login screen
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
}
