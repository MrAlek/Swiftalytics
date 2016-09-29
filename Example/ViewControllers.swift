//
// ViewControllers.swift
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

class AuthorsViewController: UITableViewController {
    var authors: [Author]!
    let cellIdentifier = "cell"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "show quote" {
            let cell = sender! as! UITableViewCell
            let index = (tableView.indexPath(for: cell)! as NSIndexPath).row
            
            let qvc = segue.destination as! QuoteViewController
            qvc.author = authors[index]
        }
    }
}

extension AuthorsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    
        cell?.textLabel?.text = authors[(indexPath as NSIndexPath).row].name
        
        return cell!
    }
}

class QuoteViewController: UIViewController {
    var author: Author!
    @IBOutlet weak var quoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = author.name
        quoteLabel.text = author.quote
    }
}

// Never loaded in UI
class NewQuoteViewController: UIViewController {}
class RandomQuoteViewController: UIViewController {
    var author: Author!
    
    func computedPageName() -> String {
        return "Random quote by \(self.author.name)"
    }
}
