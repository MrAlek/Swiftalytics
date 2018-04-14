//
// Swiftalytics.swift
//
// Created by Alek Åström on 2015-02-14.
// Copyright (c) 2015 Alek Åström. (https://github.com/MrAlek)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public enum TrackingNameType {
    case navigationTitle
}

private let storage = SWAClassBlockStorage()

public func setTrackingName<T: UIViewController>(for viewController: T.Type, name: @autoclosure () -> String) {
    let n = name()
    setTrackingName(for: viewController) {_ in n}
}

public func setTrackingName<T: UIViewController>(for viewController: T.Type, trackingType: TrackingNameType) {
    switch trackingType {
    case .navigationTitle:
        setTrackingName(for: viewController) { vc in
            if let title = vc.navigationItem.title {
                return title
            }
            
            let className = String(describing: type(of: vc))
            print("Swiftalytics: View Controller \(className) missing navigation item title")
            return className
        }
    }
}

public func setTrackingName<T: UIViewController>(for viewController: T.Type, nameFunction: @escaping ((T) -> String)) {
    let block: MapBlock = { vc in nameFunction(vc as! T) }
    storage.setBlock(block, forClass: T.value(forKey: "self")!)
}

public func setTrackingName<T: UIViewController>(for curriedNameFunction: @escaping (T) -> () -> String) {
    let block: MapBlock = { vc in curriedNameFunction(vc as! T)() }
    storage.setBlock(block, forClass:T.value(forKey: "self")!)
}

public func trackingName<T: UIViewController>(for viewController: T) -> String? {
    return storage.block(forClass: viewController.value(forKey: "class")!)?(viewController) as! String?
}

public func clearTrackingNames() {
    storage.removeAllBlocks()
}

public func removeTrackingForViewController<T: UIViewController>(_: T.Type) {
    storage.removeBlock(forClass: T.value(forKey: "self")!)
}
