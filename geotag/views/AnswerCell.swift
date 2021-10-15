//
//  AnswerCell.swift
//  geotag
//
//  Created by Ningze Dai on 10/12/21.
//

import UIKit

class AnswerCell: UITableViewCell {

    let optionLbl: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textColor = .hbGreen
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupContents()
    }
    
    private func setupContents() {
        contentView.addSubview(optionLbl)
        contentView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            optionLbl.topAnchor.constraint(equalTo: contentView.topAnchor),
            optionLbl.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            optionLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            optionLbl.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        if state.isSelected {
            contentView.backgroundColor = .hbGreen
            optionLbl.textColor = .white

            
        } else {
            contentView.backgroundColor = .white
            optionLbl.textColor = .hbGreen
            
        }
        
    }


}
