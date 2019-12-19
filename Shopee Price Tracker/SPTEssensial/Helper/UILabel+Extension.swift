//
//  ExUILabel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/4/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

extension UILabel {
    
    func addImage(_ image: UIImage, _ text: String, offsetY: CGFloat = -5.0, x: CGFloat = -2) {
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = image
        //Set bound to reposition
        
        imageAttachment.bounds = CGRect(x: x, y: offsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        completeText.append(attachmentString)
        //Add your text to mutable string
        let  textAfterIcon = NSMutableAttributedString(string: text)
        completeText.append(textAfterIcon)
        self.textAlignment = .center;
        self.attributedText = completeText;
    }
}


