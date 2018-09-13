//
//  SearchResultTVC.swift
//  SearchTest
//
//  Created by Jo JANGHUI on 2018. 9. 11..
//  Copyright © 2018년 JhDAT. All rights reserved.
//

import UIKit

protocol SearchResultTVCDelegate: class {
    func actionCancelButton(_ indexpath: IndexPath)
}

class SearchResultTVC: UITableViewCell {
    
    weak var delegate: SearchResultTVCDelegate!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    var indexpath: IndexPath?
    
    @IBAction func actionStatusButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "normal" {
            
        } else {
            delegate.actionCancelButton(indexpath!)
        }
        
    }
}
