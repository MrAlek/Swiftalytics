//
// AppDelegate.swift
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

struct Author {
    let name: String
    let quote: String
}

let authors: [Author] = [
    Author(name: "Aristotle", quote: "We are what we repeatedly do. Excellence, then, is not an act, but a habit."),
    Author(name: "Aziz Shavershian", quote: "U mirin' brah?"),
    Author(name: "Bruce Lee", quote: "Simplicity is the key to brilliance."),
    Author(name: "Napoleon Bonaparte", quote: "Impossible is a word to be found only in the dictionary of fools."),
    Author(name: "Oscar Wilde", quote: "Be yourself; everyone else is already taken")
]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override init() {
        super.init()
        UIViewController.initializeClass() // https://stackoverflow.com/questions/46361065/method-swizzling-in-swift-4/46361066#46361066
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ScreenTracking.setup()
        
        if let navc = window?.rootViewController as? UINavigationController {
            if let avc = navc.topViewController as? AuthorsViewController {
                avc.authors = authors
            }
        }
        
        return true
    }
}

