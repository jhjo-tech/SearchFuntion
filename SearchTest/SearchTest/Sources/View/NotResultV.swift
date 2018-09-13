//
//  NotResultV.swift
//  SearchTest
//
//  Created by Jo JANGHUI on 2018. 9. 12..
//  Copyright © 2018년 JhDAT. All rights reserved.
//

import UIKit

class NotResultV: UIView {
    
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        label.text = "검색어를 입력하세요"
        label.numberOfLines = 2
        label.textAlignment = .center
        let size = CGSize(width: 200, height: 50)
        label.frame = CGRect(origin: CGPoint(x: frame.midX - (size.width / 2),
                                             y: frame.minY + (size.height * 2)),
                             size: size)
        addSubview(label)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
