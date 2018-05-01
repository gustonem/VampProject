//
//  SubjectCell.swift
//  VampProject
//
//  Created by Gusto Nemec on 17/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit

protocol subjectCellDelegate {
    func didTapSubjectButton(url: String)
}

class SubjectCell: UITableViewCell {

    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    //var code: String!
    
    var delegate: subjectCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func subjectButtonTapped(_ sender: Any) {
        delegate?.didTapSubjectButton(url: "https://is.muni.cz/auth/el/1433/jaro2018/" + (codeButton.titleLabel?.text!)!)
    }
    
}
