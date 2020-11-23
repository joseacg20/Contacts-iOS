//
//  DetailTableViewCell.swift
//  Contactos CoreData
//
//  Created by Jose Angel Cortes Gomez on 16/11/20.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
//    var name: String?
//    var detail: String?
//
    @IBOutlet weak var nameCellLabel: UILabel!
    @IBOutlet weak var detailCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.nameCellLabel.text = name
//        self.detailCellLabel.text = detail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
