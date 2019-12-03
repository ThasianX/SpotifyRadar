//
//  SpotifyDailyTests.swift
//  SpotifyDailyTests
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import XCTest
@testable import SpotifyDaily

import RxSwift

class SpotifyDailyTests: XCTestCase {
    let client = Networking()
    let disposebag = DisposeBag()
    
    func testLoadingImageFromUrl(){
        let imageView = UIImageView()
        let url = URL(string: "https://scontent.xx.fbcdn.net/v/t1.0-1/p320x320/64647253_1091301777737138_2367822531211034624_n.jpg?_nc_cat=111&_nc_ohc=Pc12tvtVpn0AQn_3IsamKKm2XkWdRMI6eb02_gMXzpWqD5fU2GD6dOgIQ&_nc_ht=scontent.xx&oh=5efa3566c91e9b9192e5885a16863528&oe=5E84838E")
        imageView.load(url: url!)
        
        
        XCTAssertNotNil(imageView)
    }

}
