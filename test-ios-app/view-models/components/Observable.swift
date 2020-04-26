//
//  Observable.swift
//  MapTestApp
//
//  Created by Maxym Borodko on 26.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation

struct Observable<T> {
    typealias Observer = (T) -> Void
    
    private var observer: Observer?
    var value: T {
        didSet {
            observer?(self.value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    mutating func bind(_ observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
}
