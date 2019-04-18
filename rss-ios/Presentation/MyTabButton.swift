//
//  MyTabButton.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 05/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit

class MyTabButton: UIButton {
    var selectedView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initailize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initailize()
    }
    
    func initailize() {
        let selectedView = UIView()
        selectedView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(selectedView)
        self.rightAnchor.constraint(equalTo: selectedView.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: selectedView.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: selectedView.leftAnchor).isActive = true
        selectedView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        selectedView.isHidden = true
        self.selectedView = selectedView
        selected()
    }
    
    override var isSelected: Bool {
        didSet {
            selected()
        }
    }
    
    func selected() {
        if isSelected {
            self.selectedView?.isHidden = false
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        } else {
            self.selectedView?.isHidden = true
            self.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        }
    }
}
