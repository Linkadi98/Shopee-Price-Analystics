//
//  SplashScreenViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/13/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTwitterSplashAnimation()
        print("Did")
        // Do any additional setup after loading the view.
    }
    
    func loadTwitterSplashAnimation() -> Void {
        let splashView = SplashView(iconImage: #imageLiteral(resourceName: "logo"),iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red: 70/255, green: 154/255, blue: 233/255, alpha: 1))
        
        self.view.addSubview(splashView)
        
        splashView.duration = 5.0
        splashView.animationType = AnimationType.heartBeat
        splashView.iconColor = UIColor.red
        splashView.useCustomIconColor = false
        
        splashView.startAnimation(){
            print("Completed")
        }
        
        // This will deliver the message to stop the heartbeat
        // Need to call like same after the completion of API, means when screen transition needs.
        // Comment and run this, you will see heartbeat will never stops.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            print("Heart Attack Stopped")
            splashView.finishHeartBeatAnimation()
        })
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
