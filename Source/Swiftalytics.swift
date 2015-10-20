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
    case NavigationTitle
}

private let storage = SWAClassBlockStorage()

public func setTrackingNameForViewController<T: UIViewController>(viewController: T.Type, @autoclosure name: () -> String) {
    let n = name()
    setTrackingNameForViewController(viewController) {_ in n}
}

public func setTrackingNameForViewController<T: UIViewController>(viewController: T.Type, trackingType: TrackingNameType) {
    switch trackingType {
    case .NavigationTitle:
        setTrackingNameForViewController(viewController) { vc in
            if let title = vc.navigationItem.title {
                return title
            }
            
            let className = String(vc.dynamicType)
            print("Swiftalytics: View Controller \(className) missing navigation item title")
            return className
        }
    }
}

public func setTrackingNameForViewController<T: UIViewController>(viewController: T.Type, nameFunction: (T -> String)) {
    setTrackingNameForViewController({ vc in { nameFunction(vc) } }) // Curry
}

public func setTrackingNameForViewController<T: UIViewController>(curriedNameFunction: T -> () -> String) {
    let block: MapBlock = { vc in curriedNameFunction(vc as! T)() }
    storage.setBlock(block, forClass:T.valueForKey("self")!)
}

public func trackingNameForViewController<T: UIViewController>(viewController: T) -> String? {
    return storage.blockForClass(viewController.valueForKey("class")!)?(viewController) as! String?
}

public func clearTrackingNames() {
    storage.removeAllBlocks()
}

public func removeTrackingForViewController<T: UIViewController>(_: T.Type) {
    storage.removeBlockForClass(T.valueForKey("self")!)
}
