//
//  UIButton+RightDisclosure.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/11/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

extension UIButton
{
    /*
     Add right arrow disclosure indicator to the button with normal and
     highlighted colors for the title text and the image
     */
    func disclosureButton()
    {
        setTitleColor(ColorPreference.mainColor, for: .normal)
        
        guard let image = UIImage(named: "disclosure")?.withRenderingMode(.alwaysTemplate) else
        {
            return
        }
        
        self.imageView?.contentMode = .scaleAspectFit
        self.setImage(image, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.bounds.size.width-image.size.width*1.5, bottom: 0, right: 0);
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.backgroundColor = ColorPreference.secondaryColor
        self.tintColor = ColorPreference.mainColor
        self.contentEdgeInsets = UIEdgeInsets(top: 10,left: 0,bottom: 10,right: 0)
    }
    
}
