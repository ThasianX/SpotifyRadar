//
//  ObservableType+Extras.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/4/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where Element: Collection {

    func mapMany<T>(_ transform: @escaping (Self.Element.Element) -> T) -> Observable<[T]> {
        return self.map { collection -> [T] in
            collection.map(transform)
        }
    }
}
