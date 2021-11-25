//
//  TableViewCell.swift
//  TablePostApp
//
//  Created by 1 on 12.11.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var id = 0
    
    var isActive = false {
        didSet {
            setUp()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    
   
    @IBAction func readMoreAction(_ sender: UIButton) {
        isActive.toggle()
//       buttonLabel.titleLabel!.text = isActive ? "Меньше" : "Больше"
      buttonLabel.isHidden = true

        
       
    }
    
    
    
    func setUp() {
        newsTextLabel.numberOfLines = isActive ? 0 : 2
 
        
    }
   
    
}
